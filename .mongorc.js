prompt = function() { return "🐺 [" + db + "] > "; };
var exit = quit;

function newUser(username, password) {
  db.createUser({ user: username, pwd: password, roles: [] });
}
