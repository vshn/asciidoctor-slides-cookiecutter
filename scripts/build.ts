// Load asciidoctor.js and asciidoctor-reveal.js
import * as asciidoctorLib from 'asciidoctor.js';
import * as asciidoctorRevealjs from 'asciidoctor-reveal.js';
import * as fs from 'fs';
import * as path from 'path';

if (process.argv.length < 3) {
    console.error('build.ts: Missing "filename" parameter. Exiting');
    process.exit(1);
}

const filename = process.argv[2];
const filepath : string = path.join(__dirname, '..', filename);
if (!fs.existsSync(filepath)) {
    console.error('parse_files.ts: The path "%s" is invalid. Exiting.', filepath);
    process.exit(1);
}

const asciidoctor = asciidoctorLib();
asciidoctorRevealjs.register()

const options = {safe: 'safe', backend: 'revealjs'};
asciidoctor.convertFile(filename, options);
