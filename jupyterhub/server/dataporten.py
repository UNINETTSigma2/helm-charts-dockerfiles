import os

import json
import base64
import urllib

from tornado.httpclient import AsyncHTTPClient, HTTPRequest
from tornado.auth import OAuth2Mixin
from tornado import gen
from tornado.httputil import url_concat

from jupyterhub.auth import LocalAuthenticator
from traitlets import Unicode, Dict
from oauthenticator.oauth2 import OAuthLoginHandler, OAuthenticator

class GenericEnvMixin(OAuth2Mixin):
    _OAUTH_ACCESS_TOKEN_URL = os.environ.get('OAUTH2_TOKEN_URL', '')
    _OAUTH_AUTHORIZE_URL = os.environ.get('OAUTH2_AUTHORIZE_URL', '')


class GenericLoginHandler(OAuthLoginHandler, GenericEnvMixin):
    pass


class DataportenAuth(OAuthenticator):

    login_service = Unicode(
        "Dataporten",
        config=True
    )

    login_handler = GenericLoginHandler

    userdata_url = Unicode(
        os.environ.get('OAUTH2_USERDATA_URL', ''),
        config=True,
        help="Userdata url to get user data login information"
    )
    token_url = Unicode(
        os.environ.get('OAUTH2_TOKEN_URL', ''),
        config=True,
        help="Access token endpoint URL"
    )

    username_key = Unicode(
        os.environ.get('OAUTH2_USERNAME_KEY', 'username'),
        config=True,
        help="Userdata username key from returned json for USERDATA_URL"
    )
    userdata_params = Dict(
        os.environ.get('OAUTH2_USERDATA_PARAMS', {}),
        help="Userdata params to get user data login information"
    ).tag(config=True)

    userdata_method = Unicode(
        os.environ.get('OAUTH2_USERDATA_METHOD', 'GET'),
        config=True,
        help="Userdata method to get user data login information"
    )

    authorized_groups = Unicode(
        os.environ.get('AUTHORIZED_GROUPS', ''),
        config=True,
        help="The groups that allowed to access the application. If none are specified, all groups are allowed access."
    )

    group_urls = Unicode(
        os.environ.get('GROUP_URLS', "https://groups-api.dataporten.no/groups/me/groups"),
        config=True,
        help="A comma separated string of URLs to fetch groups from."
    )

    @gen.coroutine
    def authenticate(self, handler, data=None):
        code = handler.get_argument("code")
        # TODO: Configure the curl_httpclient for tornado
        http_client = AsyncHTTPClient()

        params = dict(
            redirect_uri=self.get_callback_url(handler),
            code=code,
            grant_type='authorization_code'
        )

        if self.token_url:
            url = self.token_url
        else:
            raise ValueError("Please set the OAUTH2_TOKEN_URL environment variable")

        b64key = base64.b64encode(
            bytes(
                "{}:{}".format(self.client_id, self.client_secret),
                "utf8"
            )
        )

        headers = {
            "Accept": "application/json",
            "User-Agent": "JupyterHub",
            "Authorization": "Basic {}".format(b64key.decode("utf8"))
        }
        req = HTTPRequest(url,
                          method="POST",
                          headers=headers,
                          body=urllib.parse.urlencode(params)  # Body is required for a POST...
                         )

        resp = yield http_client.fetch(req)

        resp_json = json.loads(resp.body.decode('utf8', 'replace'))

        access_token = resp_json['access_token']
        refresh_token = resp_json.get('refresh_token', None)
        token_type = resp_json['token_type']
        scope = (resp_json.get('scope', '')).split(' ')

        # Determine who the logged in user is
        headers = {
            "Accept": "application/json",
            "User-Agent": "JupyterHub",
            "Authorization": "{} {}".format(token_type, access_token)
        }
        if self.userdata_url:
            url = url_concat(self.userdata_url, self.userdata_params)
        else:
            raise ValueError("Please set the OAUTH2_USERDATA_URL environment variable")

        req = HTTPRequest(url,
                          method=self.userdata_method,
                          headers=headers,
                         )
        resp = yield http_client.fetch(req)
        resp_json = json.loads(resp.body.decode('utf8', 'replace'))

        username = resp_json.get(self.username_key)
        if not username:
            self.log.error("OAuth user contains no key %s: %s", self.username_key, resp_json)
            return

        if self.authorized_groups:
            authorized = False

            if username in self.authorized_groups:
                authorized = True

            if not authorized:
                _group_urls = self.group_urls.split(",")
                for g_url in _group_urls:
                    groups_req = HTTPRequest(g_url.strip(),
                                             method="GET",
                                             headers=headers
                    )
                    groups_resp = yield http_client.fetch(groups_req)
                    groups_resp_json = json.loads(groups_resp.body.decode('utf8', 'replace'))

                    # Determine whether the user is member of one of the authorized groups
                    user_group_id = [g["id"] for g in groups_resp_json]
                    for group_id in self.authorized_groups.split(","):
                        if group_id in user_group_id:
                            authorized = True
                            break

                    if authorized:
                        break

            if not authorized:
                return

        return {
            'name': username,
            'auth_state': {
                'access_token': access_token,
                'refresh_token': refresh_token,
                'oauth_user': resp_json,
                'scope': scope,
            }
        }


class LocalGenericOAuthenticator(LocalAuthenticator, DataportenAuth):

    """A version that mixes in local system user creation"""
    pass
