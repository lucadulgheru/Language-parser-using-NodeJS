"use strict";

var fs = require('fs');

var parser = require ('./grammar.js').parser;   // jison grammar.jison basically ;)
 
var data = '';  // aici o sa fie stringul din fisier



// ====================== INPUT / OUTPUT   +    TURN ON PARSER ===========================




// BASIC READ FROM FILE FUNCTION 

function read_file(){

    try {

         data = fs.readFileSync(process.argv[2]).toString();

    } 
    
    catch(err) {

        console.error(err);

    }

}

// BASIC WRITE TO FILE FUNCTION


function write_file(text){
    try {

        var filepath = '';

        if(process.argv[3]!==undefined)

            filepath = process.argv[3];

        else 
            
            filepath = process.argv[2]+'.json'; 

                fs.writeFileSync(filepath, text, 'utf8');        

     } 
     
     catch(err) {

        console.error(err);

     }

}

var error_object = {};
var type = '';

// FUNCTION WHICH STARTS THE PARSING PROCESS

function start_parser(){

        try {
            // run the parser using a string

          
                  write_file(JSON.stringify(parser.parse (data),null,2)); // parse si scriere in fisier
            
        }

        catch (e) {

                        if (e.message.includes('Lexical'))

                              type = 'lexical';

                        else type = 'syntax';

                    error_object = {

                        error: type,
                        line: 2,
                        text: e.message
                    };

                write_file(JSON.stringify(error_object,null,2));

        }
}

read_file();


start_parser();

// =================================================================================







