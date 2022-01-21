// Serialized async/ await promiseall .reduce()-loop
// Handy for inserting values into a database that depend on each other

async function serialize(value) {
  return new Promise(async (resolve, reject) => {
    const vals = value.split(',');

    async function saveInDatabase(v) {
      return new Promise(async (res, rej) => {
        // '1' takes longer to finish executing,
        // returns in order bc operations are serialized
        const _ms = v === '1' ? 500 : 50;
        setTimeout(() => {
          console.log(v, '--> done');
          res();
        }, _ms);
      });
    }

    // Serizalize using array.reduce()
    vals.reduce(function(promise, v) {
      return promise.then(function() {
        return saveInDatabase(v).then((result) => console.log(result));
      });
    }, Promise.resolve()).then(function() {
      // all done here
      console.log('resolve()');
      resolve();
    }).catch(function(err) {
      // error here
      console.error(err.message);
      reject();
    });
  });
}
async function start () {
  await serialize('1,2,3');
  console.log('--- end ---');
}
console.log('--- start ---');
start();
