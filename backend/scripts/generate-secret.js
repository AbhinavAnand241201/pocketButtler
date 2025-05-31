// Script to generate a secure random string for JWT secret
const crypto = require('crypto');

// Generate a 64-byte (512-bit) random string
const secret = crypto.randomBytes(64).toString('hex');
console.log('Generated JWT_SECRET:');
console.log(secret);

// Instructions for the user
console.log('\nCopy the above secret and add it to your .env file:');
console.log('JWT_SECRET=' + secret);
