function prompt() {
  return `🐺 [${db}] > `
}

function newUser(username, password) {
  db.createUser({ user: username, pwd: password, roles: [] })
}

const exit = quit
