const fs = require('fs');
import letterToFingerMapping from './letterToFingerMapping.es6';
 
// Returns the path to the word list which is separated by `\n` 
const wordListPath = require('word-list');
 
const wordArray = fs.readFileSync(wordListPath, 'utf8').split('\n');
//=> […, 'abmhos', 'abnegate', …]

console.log("load word list complete.");

console.log("length: ", wordArray.length);



let translateAllWords = (wordArray) => {
	let fingerSequenceToWords = {};

	for (let word of wordArray) {
		let translation = translateWordToFingerSequence(word);
		
		if (!fingerSequenceToWords[translation]) {
			fingerSequenceToWords[translation] = [word];
		}

		if (!fingerSequenceToWords[translation].includes(word)){
			fingerSequenceToWords[translation].push(word);
		}
	}

	return fingerSequenceToWords;
}


let translateWordToFingerSequence = (word) => {
	let translation = '';
	
	for (let letter of word) {
		translation += letterToFingerMapping[letter];
	}

	return translation;
};

let fingerSequenceToWords = translateAllWords(wordArray);

console.log("DONE!");

console.log("ALL equivalent to 'the'", fingerSequenceToWords[translateWordToFingerSequence('the')]);
console.log("ALL equivalent to 'send'", fingerSequenceToWords[translateWordToFingerSequence('send')]);
console.log("ALL equivalent to 'me'", fingerSequenceToWords[translateWordToFingerSequence('me')]);
console.log("ALL equivalent to 'pictures'", fingerSequenceToWords[translateWordToFingerSequence('pictures')]);


console.log("ALL equivalent to 'holy'", fingerSequenceToWords[translateWordToFingerSequence('holy')]);
console.log("ALL equivalent to 'will'", fingerSequenceToWords[translateWordToFingerSequence('will')]);
console.log("ALL equivalent to 'this'", fingerSequenceToWords[translateWordToFingerSequence('this')]);
console.log("ALL equivalent to 'work'", fingerSequenceToWords[translateWordToFingerSequence('work')]);

console.log("ALL equivalent to 'holy'", fingerSequenceToWords[translateWordToFingerSequence('holy')]);
console.log("ALL equivalent to 'shit'", fingerSequenceToWords[translateWordToFingerSequence('shit')]);
console.log("ALL equivalent to 'you'", fingerSequenceToWords[translateWordToFingerSequence('you')]);
console.log("ALL equivalent to 'are'", fingerSequenceToWords[translateWordToFingerSequence('are')]);
console.log("ALL equivalent to 'hot'", fingerSequenceToWords[translateWordToFingerSequence('hot')]);
