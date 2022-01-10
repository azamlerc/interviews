// SHA1
// https://gist.github.com/ducksoupdev/bbfcf8b9cee688b97865
module sha1 {
  var POW_2_24 = Math.pow(2, 24);
  var POW_2_32 = Math.pow(2, 32);

  function hex(n: number): string {
    var s = "",
      v: number;
    for (var i = 7; i >= 0; --i)
    {
      v = (n >>> (i << 2)) & 0xF;
      s += v.toString(16);
    }
    return s;
  }

  function lrot(n: number, bits: number): number {
    return ((n << bits) | (n >>> (32 - bits)));
  }

  class Uint32ArrayBigEndian {
    bytes: Uint8Array;
    constructor(length: number) {
      this.bytes = new Uint8Array(length << 2);
    }
    get(index: number): number {
      index <<= 2;
      return (this.bytes[index] * POW_2_24)
        + ((this.bytes[index + 1] << 16)
        | (this.bytes[index + 2] << 8)
        | this.bytes[index + 3]);
    }
    set(index: number, value: number) {
      var high = Math.floor(value / POW_2_24),
        rest = value - (high * POW_2_24);
      index <<= 2;
      this.bytes[index] = high;
      this.bytes[index + 1] = rest >> 16;
      this.bytes[index + 2] = (rest >> 8) & 0xFF;
      this.bytes[index + 3] = rest & 0xFF;
    }
  }

  function string2ArrayBuffer(s: string): ArrayBuffer {
    s = s.replace(/[\u0080-\u07ff]/g,
      function(c: string) {
        var code = c.charCodeAt(0);
        return String.fromCharCode(0xC0 | code >> 6, 0x80 | code & 0x3F);
      });
    s = s.replace(/[\u0080-\uffff]/g,
      function(c: string) {
        var code = c.charCodeAt(0);
        return String.fromCharCode(0xE0 | code >> 12, 0x80 | code >> 6 & 0x3F, 0x80 | code & 0x3F);
      });
    var n = s.length,
      array = new Uint8Array(n);
    for (var i = 0; i < n; ++i) {
      array[i] = s.charCodeAt(i);
    }
    return array.buffer;
  }

  export function hash(bufferOrString: any): string {
    var source: ArrayBuffer;
    if (bufferOrString instanceof ArrayBuffer) {
      source = <ArrayBuffer> bufferOrString;
    } else {
      source = string2ArrayBuffer(String(bufferOrString));
    }

    var h0 = 0x67452301,
      h1 = 0xEFCDAB89,
      h2 = 0x98BADCFE,
      h3 = 0x10325476,
      h4 = 0xC3D2E1F0,
      i: number,
      sbytes = source.byteLength,
      sbits = sbytes << 3,
      minbits = sbits + 65,
      bits = Math.ceil(minbits / 512) << 9,
      bytes = bits >>> 3,
      slen = bytes >>> 2,
      s = new Uint32ArrayBigEndian(slen),
      s8 = s.bytes,
      j: number,
      w = new Uint32Array(80),
      sourceArray = new Uint8Array(source);
    for (i = 0; i < sbytes; ++i) {
      s8[i] = sourceArray[i];
    }
    s8[sbytes] = 0x80;
    s.set(slen - 2, Math.floor(sbits / POW_2_32));
    s.set(slen - 1, sbits & 0xFFFFFFFF);
    for (i = 0; i < slen; i += 16) {
      for (j = 0; j < 16; ++j) {
        w[j] = s.get(i + j);
      }
      for ( ; j < 80; ++j) {
        w[j] = lrot(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
      }
      var a = h0,
        b = h1,
        c = h2,
        d = h3,
        e = h4,
        f: number,
        k: number,
        temp: number;
      for (j = 0; j < 80; ++j) {
        if (j < 20) {
          f = (b & c) | ((~b) & d);
          k = 0x5A827999;
        } else if (j < 40) {
          f = b ^ c ^ d;
          k = 0x6ED9EBA1;
        } else if (j < 60) {
          f = (b & c) ^ (b & d) ^ (c & d);
          k = 0x8F1BBCDC;
        } else {
          f = b ^ c ^ d;
          k = 0xCA62C1D6;
        }

        temp = (lrot(a, 5) + f + e + k + w[j]) & 0xFFFFFFFF;
        e = d;
        d = c;
        c = lrot(b, 30);
        b = a;
        a = temp;
      }
      h0 = (h0 + a) & 0xFFFFFFFF;
      h1 = (h1 + b) & 0xFFFFFFFF;
      h2 = (h2 + c) & 0xFFFFFFFF;
      h3 = (h3 + d) & 0xFFFFFFFF;
      h4 = (h4 + e) & 0xFFFFFFFF;
    }
    return hex(h0) + hex(h1) + hex(h2) + hex(h3) + hex(h4);
  }
}

// BASE64

function bin2String(numbers: number[]): string {
  return numbers.map((i) => String.fromCharCode(i)).join("");
}

const b64ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
const b64chs = Array.prototype.slice.call(b64ch);

function btoaPolyfill(bin: string): string {
    // console.log('polyfilled');
    let u32, c0, c1, c2, asc = '';
    const pad = bin.length % 3;
    for (let i = 0; i < bin.length;) {
        if ((c0 = bin.charCodeAt(i++)) > 255 ||
            (c1 = bin.charCodeAt(i++)) > 255 ||
            (c2 = bin.charCodeAt(i++)) > 255)
            throw new TypeError('invalid character found');
        u32 = (c0 << 16) | (c1 << 8) | c2;
        asc += b64chs[u32 >> 18 & 63]
            + b64chs[u32 >> 12 & 63]
            + b64chs[u32 >> 6 & 63]
            + b64chs[u32 & 63];
    }
    return pad ? asc.slice(0, pad - 3) + "===".substring(pad) : asc;
};

// UTILS

function byteArray(n: number): number[] {
  let numbers: number[] = [];
  while (n > 255) {
    numbers.push(Math.floor(n / 256));
    n = n % 256;
  }
  numbers.push(n);
  return numbers;
}

function randomNumbers(count: number): number[] {
  return [...Array(count)].map((_) => 
     Math.floor((Math.random() * 256) + 1));
}

function makeDate() {
  let today = new Date();
  let iso = today.toISOString();
  return iso.substring(2,4) + 
    iso.substring(5,7) + 
    iso.substring(8,10) + 
    iso.substring(11,13) + 
    iso.substring(14,16);
}

function makeRand() {
  return btoaPolyfill(bin2String(randomNumbers(12)));
}

function encodeNumber(n: number) {
  return btoaPolyfill(bin2String(byteArray(n)));
}

function zeroPrefix(bytes: number): string {
  return [...Array(Math.floor(bytes / 4))].map((_) => "0").join("");
}

// HASHCASH

let email = "anni@cypherspace.org";
let defaultBits = 12;

interface Hashcash {
  ver: number;
  bits: number;
  date: string;
  resource: string;
  ext: string;
  rand: string;
  counter: string;
}

function join(h: Hashcash, includeCounter: boolean = true): string {
  let vals = [h.ver, h.bits, h.date, h.resource, h.ext, h.rand, includeCounter ? h.counter : ""];
  return vals.join(":");
}

function parse(value: string): Hashcash {
  let values = value.split(":");
  let hashcash = {
    ver: parseInt(values[0]),
    bits: parseInt(values[1]),
    date: values[2],
    resource: values[3],
    ext: values[4],
    rand: values[5],
    counter: values[6]
  };
  return hashcash;
}

function findCounter(hashcash: Hashcash) {
  let prefix = join(hashcash, false);
  let zeroes = zeroPrefix(hashcash.bits);
  let found = false;
  for (let i = 0; !found; i++) {
    let counter = encodeNumber(i);
    let hash = sha1.hash(prefix + counter);
    if (hash.startsWith(zeroes)) {
      hashcash.counter = counter;
      found = true;
    }
  }
}

function generate(resource: string): string {
  let hashcash = {
    ver: 1,
    bits: defaultBits,
    date: makeDate(),
    resource,
    ext: "",
    rand: makeRand(),
    counter: ""
  };

  findCounter(hashcash);
  return join(hashcash);
}

function validate(value: string, resource: string): boolean {
  let hashcash = parse(value);

  // version is correct
  if (hashcash.ver != 1) {
    console.log("Unknown version");
    return false;
  }
  // date is the same day
  if (!hashcash.date.startsWith(makeDate().substring(0,6))) {
    console.log("Not the same day");
    return false;
  }
  // resource is the same
  if (resource != hashcash.resource) {
    console.log("Resource not the same");
    return false;
  }
  // random data is correct length
  if (hashcash.rand.length < 16) {
    console.log("Random too short");
    return false;
  }
  // SHA1 hash has correct number of leading zeros
  let hash = sha1.hash(value);
  let zeroes = zeroPrefix(hashcash.bits);
  if (!hash.startsWith(zeroes)) {
    console.log("Hash doesn't start with zeroes");
    return false;
  }
  
  return true;
}

let value = generate(email);
console.log(value);
if (validate(value, email)) {
  console.log("Validated");
}
