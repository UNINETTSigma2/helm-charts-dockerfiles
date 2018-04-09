
var settings 				= require('ep_etherpad-lite/node/utils/Settings'),
    exp 					= require('ep_etherpad-lite/node_modules/express'),
    passport 				= require('passport'),
    DataportenStrategy 		= require('passport-dataporten').Strategy,
    bodyParser 				= require('body-parser'),
   	EAPI 					= require('./lib/EAPI.js'),
    json 					= require('express-json'),
    session 				= require('express-session');

var redirectUri = process.env.TLS == "true" ? "https://" + process.env.HOST : "http://" + process.env.HOST || settings.ep_dataporten.host;
var config = {
	clientID: process.env.DATAPORTEN_CLIENTID || settings.ep_dataporten.clientId,
	clientSecret: process.env.DATAPORTEN_CLIENTSECRET || settings.ep_dataporten.clientSecret,
	callbackURL: redirectUri + "/dataporten/callback",
}

passport.use(new DataportenStrategy(config,
	function(accessToken, refreshToken, profile, cb) {
		profile.loadGroups().then(function() {
			return cb(null, profile);
		}).catch(function(err) {
			return cb(err);
		});
	}
));

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});

exports.authenticate = function(hook_name, args, cb) {
	console.log("   >>>>> EXPRESS HOOK authenticate");
	console.log();

	args.res.writeHead(200, {"Content-Type": "text/plain"});
	args.res.end("No access.");

}

exports.authorize = function(hook_name, args, cb) {
	console.log("   >>>>> EXPRESS HOOK authorize");
	for(var key in args) {
		console.log("ARG " + key);
	}
	console.log("Resource " + args.resource )

	return cb([true]);
}

exports.expressConfigure = function (hook_name, args, cb) {
	var app = args.app;

	app.set('trust proxy', 1) // trust first proxy
	app.use(session({
	  secret: 'keyboard cat',
	  resave: false,
	  saveUninitialized: true,
	  cookie: { secure: true }
	}));

	app.use(bodyParser.json());       // to support JSON-encoded bodies
	app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
	  extended: true
	}));
	app.use(json());       // to support JSON-encoded bodies
	app.use(passport.initialize());
	app.use(passport.session());

	app.get('/auth/dataporten', passport.authorize('dataporten'));
	app.get('/dataporten/callback', passport.authorize('dataporten', { failureRedirect: '/login' }),
    function(req, res) {
    	req.session.user = req.account;
       	res.redirect("/");
    });

    app.use('/logout', function(req, res) {
		req.session.destroy();
		res.redirect("https://auth.dataporten.no/logout");
	});

    app.use('/p/',  function(req, res, next) {

		var maxAge = 3600*24*365;
		var until =  (new Date).getTime() + (maxAge);

		console.log("Middleware to do session handling");

		if (!req.cookies['sessionID']) {

			console.log("Session cookie is not set, obtaining new session.");


			EAPI.getSession(req.session.user, function(data) {
				var sessionID = data.join(',');
				console.log("Setting session ID ", sessionID);
				res.cookie('sessionID', sessionID, { "maxAge": maxAge, "httpOnly": false });
				next();
			});
		} else {
			console.log("Session cookie is set");
			next();
		}

	});

    app.use('/p/', function(req, res, next) {
		next();
	});

    app.get('/dashboard-api/setupSession', function(req, res, next) {

		var maxAge = 3600*24*365;
		var until =  (new Date).getTime() + (maxAge);
		var body = "Creating session\n\n";

		EAPI.getSession(req.session.user, function(data) {

			var sessionID = data.join(',');

			body += 'Setting session identifier in sessionID Cookie: ' + sessionID + "\n";


			res.cookie('sessionID', sessionID, { "maxAge": maxAge, "httpOnly": false });

			res.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
			res.end(body);

		});

	});

	app.get('/dashboard-api/session', function(req, res, next) {


		EAPI.getSession(req.session.user, function(data) {

			var body = '';
			body += "\n\nSession data: \n" + JSON.stringify(data, undefined, 2);


			body += "\nGroups:\n" + JSON.stringify(req.session.user.groups, undefined, 2);
			res.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
			res.end(body);

		});


	});

	app.get('/dashboard-api/padshtml', function(req, res, next) {
		EAPI.listPads(req.session.user, function(data) {
			res.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});

			var body = '';
			body += '<h2>List of pads</h2>';
			body += '<ul>';
			for(var i =0; i < data.length; i++) {
				body += '<li><a target="_blank" href="/p/' + data[i].padID + '">' + data[i].padID + '</a>' +
					'<pre>' + JSON.stringify(data[i], undefined, 2) + '</pre>' +
					'</li>';
			}
			if (data.length === 0) {
				body += '<li style="color: #ccc">No pads available</li>';
			}

			body += '</ul>';


			res.end(body);
		});

	});

	app.get('/dashboard-api/userinfo', function(req, res, next) {
		res.writeHead(200, {"Content-Type": "application/json; charset=utf-8"});
		res.end(JSON.stringify(req.session.user, undefined, 2));
	});

	app.get('/dashboard-api/pads', function(req, res, next) {
		EAPI.listPads(req.session.user, function(data) {
			res.writeHead(200, {"Content-Type": "application/json; charset=utf-8"});
			res.end(JSON.stringify(data, undefined, 2));
		});
	});

	app.post('/dashboard-api/pad/create', function(req, res, next) {
		var newObject = req.body;

		EAPI.createPad(newObject.name, newObject.groupid, function(data) {
			res.writeHead(200, {"Content-Type": "application/json; charset=utf-8"});
			res.end(JSON.stringify(data, undefined, 2));

		});
	});

	app.get('/login', function(req, res, next) {
		res.end("You need to authenticate first");
	});

	app.use('/', function (req, res, next) {
			if(req.session.user && req.session.user.data.provider == "Dataporten") {
				next();
			} else {
				res.redirect('/auth/dataporten');
			}
	});

	app.use('/', exp.static(__dirname + '/webapp/'));
};
