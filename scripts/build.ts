// Drives the creation of the Reveal.js presentation using
// the asciidoctor-reveal.js JavaScript library.
import * as asciidoctorLib from 'asciidoctor.js';
import * as asciidoctorRevealjs from 'asciidoctor-reveal.js';
import * as fs from 'fs';
import * as path from 'path';

// Check that there is a parameter
if (process.argv.length < 3) {
    console.error('build.ts: Missing "filename" parameter. Exiting');
    process.exit(1);
}

// Check that the parameter points to a file that exists
const filename = process.argv[2];
const filepath : string = path.join(__dirname, '..', filename);
if (!fs.existsSync(filepath)) {
    console.error('parse_files.ts: The path "%s" is invalid. Exiting.', filepath);
    process.exit(1);
}

// Drive the transformation from Asciidoc to HTML
const asciidoctor = asciidoctorLib();
asciidoctorRevealjs.register();
const options = {safe: 'safe', backend: 'revealjs'};
asciidoctor.convertFile(filename, options);
