// Parallelized async/ await promiseall .map()-loop
// Handy for inserting values into a database all at once
// (be sure to open enough db connections)

async function parallelize(value) {
  return new Promise(async (resolve, reject) => {
    const vals = value.split(',');
    const loop = async() => {
      console.log('loop()');
      // Use array.map() to parallelize operations
      const promises = await vals.map(async v => {
        const execQuery = new Promise((res, rej) => {
          // '1' takes longer to finish executing,
          // returns last bc operations are parallelized
          const _ms = v === '1' ? 500 : 50;
          setTimeout(() => {
            console.log(v, '--> done');
            res();
          }, _ms);
        });
        return execQuery;
      });
      await Promise.all(promises);
      console.log('resolve()');
      resolve();
    };
    loop();
  });
};
async function start () {
  await parallelize('1,2,3');
  console.log('--- end ---');
}
console.log('--- start ---');
start();
