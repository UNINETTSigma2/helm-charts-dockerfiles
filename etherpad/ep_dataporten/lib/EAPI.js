var 
	express = require('ep_etherpad-lite/node_modules/express'),
	async = require('async');

// var settings = require('/Users/andreas/wcn/etherpad-lite/src/node/utils/Settings');
var settings = require('ep_etherpad-lite/node/utils/Settings');
// var API = require('/Users/andreas/wcn/etherpad-lite/src/node/db/API');
var API = require('ep_etherpad-lite/node/db/API');


// User => authorID
var getAuthorID = function(user, callback) {
	API.createAuthorIfNotExistsFor(user.data.id, user.data.displayName, function(err, author) {
		callback(author.authorID);
	});
}



/**
 * Resolve from a feide connect groupid an etherpad groupid.
 */
var resolveGroupID = function(fcgroup, callback) {

	// console.log("resolveGroupID [group " + fcgroup + "]");
	API.createGroupIfNotExistsFor(fcgroup, function(err, group) {
		// console.log("resolveGroupID [group " + fcgroup + "] to " + group.groupID);
		callback(group.groupID);
	});
}

/**
 * Resolve session ID from feide connect group id. 
 */
var resolveSessionFromGroupID = function(authorid, groupid, callback) {

	console.log("resolveSessionFromGroupID [author " + authorid + "] [group " + groupid + "]");

	// resolveGroupID(fcgroup, function(groupid) {

		// console.log("createGroupIfNotExistsFor [group " + groupid + "] becomes [" + groupid + "]");

	var maxAge = 3600*24*365;
	var until =  (new Date).getTime() + (maxAge);
	API.createSession(groupid, authorid, until, function(err, sess) {

		// console.log("Errr", err);
		// console.log("Sess", sess);

		callback(sess.sessionID);

	});


	// });

}



var getPadInfo = function(pad, callback) {

	var operations = [
		'getRevisionsCount', 'padUsersCount', 'padUsers', 'getReadOnlyID', 'getPublicStatus', 'listAuthorsOfPad', 'getLastEdited'
	];

	console.log("looking up padinfo for " + pad.padid);

	async.map(operations, function(operation, callback) {

		API[operation](pad.padid, function(err, data) {
			callback(null, data);
		});

	}, function(err, results){



		// results is now an array of stats for each file
		// console.log("Results, async obtaining group identifiers: ", results);

		var ip = pad.padid.split('$');
		pad.egroup = ip[0];
		pad.name = ip[1];

		for(var i = 0; i < results.length; i++) {
			for(var key in results[i]) {
				if (results[i].hasOwnProperty(key)) {
					pad[key] = results[i][key];
				}
			}
		}

		callback(pad);

	});


	// API.getRevisionsCount(padID, function(err, data) {
	// 	console.log("getPadInfo getRevisionsCount", JSON.stringify(data, undefined, 2));
	// });
	// API.padUsersCount(padID, function(err, data) {
	// 	console.log("getPadInfo padUsersCount", JSON.stringify(data, undefined, 2));
	// });
	// API.padUsers(padID, function(err, data) {
	// 	console.log("getPadInfo padUsers", JSON.stringify(data, undefined, 2));
	// });
	// API.getReadOnlyID(padID, function(err, data) {
	// 	console.log("getPadInfo getReadOnlyID", JSON.stringify(data, undefined, 2));
	// });
	// API.getPublicStatus(padID, function(err, data) {
	// 	console.log("getPadInfo getPublicStatus", JSON.stringify(data, undefined, 2));
	// });
	// API.listAuthorsOfPad(padID, function(err, data) {
	// 	console.log("getPadInfo listAuthorsOfPad", JSON.stringify(data, undefined, 2));
	// });
	// API.getLastEdited(padID, function(err, data) {
	// 	console.log("getPadInfo getLastEdited", JSON.stringify(data, undefined, 2));
	// });
}



var listGroupPads = function(fcgroupid, callback) {

	resolveGroupID(fcgroupid, function(groupid) {
		API.listPads(groupid, function(err, list) {
			var groupPads = {
				"groupid": fcgroupid,
				"pads": list.padIDs
			};
			callback(groupPads);
		});
	});
};

var listPads = function(user, callback) {

	var fcgroupids = getFCGroupIDs(user);
	async.map(fcgroupids, function(fcgroupid, callback) {

		// console.log("Looking up groups for " + fcgroupid);

		listGroupPads(fcgroupid, function(padids) {
			callback(null, padids);
		});

	}, function(err, results){
		// results is now an array of stats for each file
		// console.log("Results, async obtaining pads within set of groups: ", results);
		// callback(results);

		var i,j, allPads = [];

		for(i=0; i < results.length; i++) {
			for(j = 0; j < results[i].pads.length; j++) {
				allPads.push({
					"groupid": results[i].groupid,
					"padid": results[i].pads[j]
				});
			}
		}

		console.log("All pads ", allPads);

		if (allPads.length < 1) {
			return callback([]);
		}

		async.map(allPads, function(pad, callback) {
			getPadInfo(pad, function(o) {
				callback(null, o);
			})
		}, function(e, res) {

			// console.log("result of getPadInfo() ", res);

			var sortedres = res.sort(function(a,b) {
				// console.log("About to sort", a.lastEdited, b.lastEdited);
				return b.lastEdited - a.lastEdited;
			});


			callback(sortedres);
		});

		// callback(allPads);

	});


	// g.PrKhjZ545lu5AolA
	

}


var createPad = function(name, fcgroupid, callback) {

	var startText = 'start';

	resolveGroupID(fcgroupid, function(groupid) {

		API.createGroupPad(groupid, name, startText, function(err, data) {

			callback(data);

		});

	});

};


var getFCGroupIDs = function(user) {
	var fcgroupids = [];

	for(var i = 0; i < user.groups.length; i++) {
		fcgroupids.push(user.groups[i].id);
	}
	return fcgroupids;
}


var getGroupIDs = function(user, callback) {

	var fcgroupids = getFCGroupIDs(user);
	getAuthorID(user, function(authorID) {
		console.log(authorID);
		async.map(fcgroupids, function(fcgroupid, callback) {

			resolveGroupID(fcgroupid, function(groupid) {
				callback(null, groupid);
			});

		}, function(err, results){
			// results is now an array of stats for each file
			// console.log("Results, async obtaining group identifiers: ", results);
			callback(results, authorID);

		});

	});

}




var getSession = function(user, callback) {


	getGroupIDs(user, function(groupids, authorID) {

		async.map(groupids, function(groupid, callback) {

			resolveSessionFromGroupID(authorID, groupid, function(sessionid) {
				callback(null, sessionid);
			})

		}, function(err, results){
			// results is now an array of stats for each file
			console.log("Results, async: ", results);
			callback(results);

		});


	});


};






var _getSession = function(user, callback) {



	console.log("User", user);
	API.createAuthorIfNotExistsFor(user.userid, user.name, function(err, author) {



		API.createGroupIfNotExistsFor('uwap:grp:uninett:org:orgunit:AVD-U2', function(err, group) {

			// groupID, padName, text, callback

			console.log("Creating for group " + group.groupID);
			// API.createGroupPad(group.groupID, 'SharedSFUPad', 'This pad is shared with the SFU group.', function(res) {


			API.listPads('g.PrKhjZ545lu5AolA', function(err, list) {



				API.createGroupPad('g.PrKhjZ545lu5AolA', 'testtwo', 'start', function(err, data) {

					var maxAge = 3600*24*365;
					var until =  (new Date).getTime() + (maxAge);
					API.createSession('g.PrKhjZ545lu5AolA', 'a.l8wNXHWtXeongVrW', until, function(err, sess) {


						res.cookie('sessionID',sess.sessionID, { "maxAge": maxAge, "httpOnly": false });

						body += "\n\nURL http://localhost:3000/p/" + list.padIDs[0];


						body += "\n\nsession: " + JSON.stringify(sess, undefined, 2);
						body += "\n\nlist: " + JSON.stringify(list, undefined, 2);
						body += "\n\nPAD CREATED: " + err + " " + JSON.stringify(data, undefined, 2);
						body += "\n\nAuthor: " + JSON.stringify(author, undefined, 2);
						body += "\n\nGroup: " + JSON.stringify(group, undefined, 2);
						body += "\n\nUser object" + JSON.stringify(req.session.user, undefined, 2);

						res.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
						res.end(body);	

					});



				});



			});



		});


	});


}


exports.getSession = getSession;
exports.createPad = createPad;
exports.listPads = listPads;