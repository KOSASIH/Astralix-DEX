import { encrypt, decrypt } from 'crypto-js';

const secretKey = 'astralixdex_secret_key';
const dataToEncrypt = ' sensitive_data ';

const encryptedData = encrypt(dataToEncrypt, secretKey);
console.log(encryptedData); // Output: encrypted data

const decryptedData = decrypt(encryptedData, secretKey);
console.log(decryptedData); // Output: sensitive_data
