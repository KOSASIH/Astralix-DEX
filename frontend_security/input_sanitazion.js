import DOMPurify from 'dompurify';

const userInput = '<script>alert("XSS");</script>';
const sanitizedInput = DOMPurify.sanitize(userInput);

console.log(sanitizedInput); // Output: &lt;script&gt;alert("XSS");&lt;/script&gt;
