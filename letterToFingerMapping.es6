
let numberToFingerMapping = {
  1: 'lh-p',
  2: 'lh-f',
  3: 'lh-m',
  4: 'lh-i',
  5: 'lh-t',
  6: 'rh-t',
  7: 'rh-i',
  8: 'rh-m',
  9: 'rh-f',
  10: 'rh-p'
};


let letterToFingerMapping = {
	a: 1,
	b: 4,
  c: 4,
  d: 3,
  e: 3,
  f: 4,
  g: 4,
  h: 7,
  i: 8,
  j: 7,
  k: 8,
  l: 9,
  m: 7,
  n: 7,
  o: 9,
  p: 10,
  q: 1,
  r: 4,
  s: 2,
  t: 4,
  u: 7,
  v: 4,
  u: 7,
  w: 2,
  x: 2,
  y: 7,
  z: 1
};

function groupByValue(obj) {
  let grouped = {};

  if (typeof obj !== 'object') {
    return grouped;
  }

  Object.keys(obj).forEach((key) => {

    if (!grouped[obj[key]]) {
      grouped[obj[key]] = [key];
      return;
    }

    grouped[obj[key]].push(key);
  });

  return grouped;
};

export default letterToFingerMapping;
