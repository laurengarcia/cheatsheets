// Async-Await are just syntax sugar for Promises
// https://javascript.info/async-await

// Async keyword
// just means the function always returns a promise
// even if a fn actually returns a non-promise value, prepending `async`
// tells js to automatically wrap value in a resolved promise
async function f() {
  return 1;
}
f().then(alert); // 1

// Await keyword
// works only inside async functions,
// !cant use `await` in regular fns!
let value = await promise;

// fn execution pauses at the `await`, resumes when promise settles
async function f() {
  let promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("done!"), 1000)
  });
  let result = await promise; // wait till the promise resolves (*)
  alert(result); // "done!"
}
f();

// Class methods: just add `async`
class Waiter {
  async wait() {
    return await Promise.resolve(1);
  }
}

new Waiter()
  .wait()
  .then(alert); // 1

// Error handling
// Two approaches:
//   - try/catch inside of async fn
//   - .catch() handler when calling async fn
async function f() {
  try {
    let response = await fetch('/no-user-here');
    let user = await response.json();
  } catch(err) {
    // catches errors both in fetch and response.json
    alert(err);
  }
}
f();

// OR
async function f() {
  let response = await fetch('http://no-such-url');
}
// f() becomes a rejected promise
f().catch(alert); // TypeError: failed to fetch


// Await accepts Thenables
class Thenable {
  constructor(num) {
    this.num = num;
  }
  then(resolve, reject) {
    alert(resolve); // function() { native code }
    // resolve with this.num*2 after 1000ms
    setTimeout(() => resolve(this.num * 2), 1000); // (*)
  }
};

async function f() {
  // waits for 1 second, then result becomes 2
  let result = await new Thenable(1);
  alert(result);
}
f();

// Call async from non-async
// just use .then() syntax instead of `await` keyword
async function wait() {
  await new Promise(resolve => setTimeout(resolve, 1000));
  return 10;
}

function f() {
  // shows 10 after 1 second
  wait().then(result => alert(result));
}
f();

// Example AJAX call
async function loadJson(url) { // (1)
  let response = await fetch(url); // (2)
  if (response.status == 200) {
    let json = await response.json(); // (3)
    return json;
  }
  throw new Error(response.status);
}

loadJson('no-such-user.json')
  .catch(alert); // Error: 404 (4)



