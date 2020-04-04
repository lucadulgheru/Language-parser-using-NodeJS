
%{


function manipulate_str(str){

    str = str.replace('\"','');

    str = str.slice(0,str.length-1);

        return str;
        
}



var vars = {};

var placeholder_object_type;    

var placeholder_object_title;

var list=[];

var struct_properties = [];

var param_list = [];

var statement_list = [];


function isDefined (variable) {   // VERIFICARE DACA VARIABILA DATA A FOST DECLARATA

			if(list.indexOf(variable) >= 0) {
				return true;
			}

				return false;
}


%}
 

%left '+' '-'
%left '*' '/' '%'
%left AND OR
%right NOT



%% 
 
module: 

  expressions {

          		return {
									id: 'module',
									statements: $1,
									line: yylineno +1
				}

	}

;

expressions:  

          statement NEWLINE expressions	{
										
											 $3.splice (0, 0, $1); // add the expression to the array produced by expressions ($3)
											 $$ = $3;

										}

					| statement expressions	{

											 $2.splice (0, 0, $1); // add the expression to the array produced by expressions ($3)
											 $$ = $2;

										}


					| statement NEWLINE		{
								
									 $$ = [$1]; 

								}

					| statement	{
						
					
							$$ = {
										type: 'statement',
										value: $1,
										line: yylineno + 1

										}

							 $$ = [$1]; // an array with one element
					}
;

statement: 

					
					loops END ';' {

								$$ = $1;


					}

					| loops ';' {

								$$ = $1;

					}

					| if_statement END ';'{

								$$ = $1;

					}

					| class END ';' {

								$$ = $1;


					}

					| arrays ';' {

								$$ = $1;

					}

        	|  variable ';' {
                    
									$$ = $1;

                    }

            
          |  expr ';' {
                   	$$ = $1;
                }


            | fn {
            		
									$$ = $1;

            		}


						| fn_start {

									$$ = $1;

						}

						| ';' {

            $$ = {
                type: 'empty'
            }


        };


fn: 


		FN IDENTIFIER OF type '=>' expr ';' {


				$$ = {

						id: 'fn',
						title: $2,
						parameters: [],
						return_type: $4,
						statements: [$6],
						line: yylineno+1

				}

		}


	|	FN IDENTIFIER OF type LP param RP '=>' statement {

					$$ = {


							id: 'fn',
							title: $2,
							parameters: param_list,
							return_type: $4,
							statements: [$9],
							line:yylineno+1
					}


		}


		|	FN IDENTIFIER OF type LP param RP BEGIN variable ';' END ';' {

					$$ = {

							id: 'fn',
							title: $2,
							parameters: param_list,
							return_type: $4,
							statements: [$9],
							line: yylineno+1

					}

		}


		|	FN IDENTIFIER OF type LP param RP BEGIN ';' END ';' {

					$$ = {

							id: 'fn',
							title: $2,
							parameters: param_list,
							return_type: $4,
							statements: [{type:'empty'}],
							line: yylineno+1

					}

		}

		|	FN IDENTIFIER OF type LP param RP BEGIN variable ';' RET expr ';' END ';' {

					var r = {

								id: 'return',
								value: $12,
								line: yylineno
					}

					$$ = {

							id: 'fn',
							title: $2,
							parameters: param_list,
							return_type: $4,
							statements: [$9,r],
							line:yylineno+1

					}

		}


	| FN IDENTIFIER OF type BEGIN fn_statements END ';' {


				$$ = {

							id: 'fn',
							title: $2,
							parameters: [],
							return_type: $4,
							statements: statement_list,
							line:yylineno+1
					}



	}


;


fn_start:


			IDENTIFIER LP IDENTIFIER OF expr RP ';' {


						$$ = {

									id: 'function_call',
									function: $1,
									parameters: {text:$5},
									line: yylineno+1

						}	

			}


			| IDENTIFIER LP RP ';' {


					$$ = {

								id: 'function_call',
								function: $1,
								parameters: [],
								line:yylineno+1



					}


			}

;


fn_statements:


				fn_statements STRING_VALUE ';' {

										
																		$$ = {

																			id: 'value',
																			type: 'string',
																			value: JSON.parse($2),
																			line: yylineno + 1

															}

															statement_list.push($$);


				}


				| STRING_VALUE ';' {
											
																		$$ = {

																			id: 'value',
																			type: 'string',
																			value: JSON.parse($1),
																			line: yylineno + 1

															}
															statement_list.push($$);
											}


;

param:


param ',' IDENTIFIER OF type {


			$$ = {

					type: $5,
					name: $3

			}

			param_list.push($$);


}



|	IDENTIFIER OF type {


			$$ = {

					type: $3,
					name: $1

			}

			param_list.push($$);

	}
;

arrays:

		IDENTIFIER OF type '[' INTEGER_NUMBER TO INTEGER_NUMBER ']' {

					$$ = {

							id: 'array',
							title: $1,
							element_type: $3,
							from: $5,
							to: $7,
							line: yylineno+1

					}

		}


;

class: 

		STRUCT IDENTIFIER {

				$$ = {

						id: 'struct',
						title: $2,
						properties: []

				}

		}


		| STRUCT IDENTIFIER class_property {

				$$ = {

						id: 'struct',
						title: $2,
						properties: struct_properties

				}

		}

;

class_property: 


			class_property PROPERTY IDENTIFIER OF type ';' {

						$$ = {
								type: $5,
								title: $3,
								line: yylineno+1

						}

				struct_properties.push($$);

			}



			| class_property PROPERTY IDENTIFIER OF type ATTRIBUTION expr ';' {

						$$ = {
								type: $5,
								title: $3,
								value: $7,
								line: yylineno+1

						}

				struct_properties.push($$);

			}


			|	PROPERTY IDENTIFIER OF type ATTRIBUTION expr ';' {

						$$ = {
								type: $4,
								title: $2,
								value: $6,
								line: yylineno+1

						}

				struct_properties.push($$);

			}


		|	PROPERTY IDENTIFIER OF type ';' {

						$$ = {
								type: $4,
								title: $2,
								line: yylineno+1

						}

				struct_properties.push($$);

			}


	
;


if_statement:

		  IF compare THEN variable ';' {

						$$ = {

									id: 'if',
									exp: $2,
									then: [$4],
									line: yylineno+2

						}
			}

			| IF compare THEN variable ';' ELSE variable ';' {

						$$ = {

									id: 'if',
									exp: $2,
									then: [$4],
									else: [$7],
									line: yylineno+2

						}
			}



;

loops: 

			FOR IDENTIFIER FROM expr TO expr RUN variable ';' {

						$$ = {

									id: 'for',
									variable: $2,
									from: $4,
									to: $6,
									statements: [$8],
									line: yylineno+2						


						}

			}

			| 	FOR IDENTIFIER IN expr RUN variable ';' {

						$$ = {

									id: 'for',
									variable: $2,
									exp: $4,
									statements: [$6],
									line: yylineno+2						


						}

			}

			|  LOOP variable ';' WHEN compare {

						$$ = {

									id: 'loop_when',
									exp: $5,
									statements: [$2],
									line: yylineno+1

						}


			}


			|  LOOP compare RUN variable ';' {

						$$ = {

									id: 'loop_run',
									exp: $2,
									statements: [$4],
									line: yylineno+2

						}


			}


;

compare: 

	 expr '<' expr	{ 

				$$ = {
					id: 'exp',
					op: '<',
					left: $1,
					right: $3,
					line: yylineno + 1
				}
			}

				| expr '>' expr	{ 

				$$ = {
					id: 'exp',
					op: '>',
					left: $1,
					right: $3,
					line: yylineno + 1
				}
			};


expr:	

			 expr '+' expr	{ 

				$$ = {
					id: 'exp',
					op: '+',
					left: $1,
					right: $3,
					line: yylineno + 1
				}
			}

      | expr '-' expr 	{
				
						$$ = {
					id: 'exp',
					op: '-',
					left: $1,
					right: $3,
					line: yylineno + 1
				}

      			}
      | expr '*' expr	{ 
    		

						$$ = {
					id: 'exp',
					op: '*',
					left: $1,
					right: $3,
					line: yylineno + 1
				}

			}

      | expr '/' expr 	{

    				$$ = {
					id: 'exp',
					op: '/',
					left: $1,
					right: $3,
					line: yylineno + 1
				}

			}

		
											|	REAL_NUMBER { 

																$$ = {

																id: 'value',
																type: 'real',
																value: Number($1),
																line: yylineno + 1

															}

															statement_list.push($$);
											}


											| INTEGER_NUMBER	{ 
										

																$$ = {

																id: 'value',
																type: 'integer',
																value: parseInt($1),
																line: yylineno + 1

															}

															statement_list.push($$);
											}


											| SYMBOL  {

																$$ = {

																				id: 'value',
																				type: 'character',
																				value: JSON.parse($1),
																				line: yylineno +1

																}
																statement_list.push($$);
												}


												| STRING_VALUE {
											
																		$$ = {

																			id: 'value',
																			type: 'string',
																			value: JSON.parse($1),
																			line: yylineno + 1

															}
															statement_list.push($$);
											}


												| TRUE  {

																$$ = {

																		id: 'value',
																		type: 'logic',
																		value: true,
																		line: yylineno +1

																}
																statement_list.push($$);
												}


												| FALSE  {

																$$ = {

																				id: 'value',
																				type: 'logic',
																				value: false,
																				line: yylineno +1

																}
																statement_list.push($$);
												}


										| IDENTIFIER {

													$$ = {
													id: 'identifier',
												  title: $1,
													line: yylineno + 1
												}

												
										}
										

											| NONE  {


														$$ = {

																id: 'value',
																type: 'none',
																line: yylineno+1 

														}

											}

    ;

variable: DEF variables  {

							$$ = {
								id: 'def',
								elements: $2,
								line: yylineno + 1
							};

						}				

			|	DEF IDENTIFIER ATTRIBUTION expr {

				

						$$ = {
								id: 'def',
								elements: [{ type:"auto",
														title: $2,
														value:$4,
														line:yylineno+1}],
								line: yylineno+1
							};


								}
				
				
		|	DEF assign {

				$$ = {

								id: 'def',
								elements: list,
								line: yylineno + 1
				};

		}

		| IDENTIFIER ATTRIBUTION expr {


							$$ = {
								id: 'set',
								to: {
									id: 'identifier',
									title: $1,
									line: yylineno + 1
								},

								from: $3,
								line: yylineno + 1
							};
							
						}

		| IDENTIFIER ATTRIBUTION fn_start {


							$$ = {
								id: 'set',
								to: {
									id: 'identifier',
									title: $1,
									line: yylineno + 1
								},

								from: $3,
								line: yylineno + 1
							}
							
						};


assign: 


				variables ATTRIBUTION expr {

			

							list.push({ type: placeholder_object_type, title: placeholder_object_title, value:$3, line: yylineno+1});

				}


				| assign ',' variables ATTRIBUTION expr {


						list.push({ type: placeholder_object_type, title: placeholder_object_title, value:$5, line: yylineno+1});

		

				}

;

variables: 


	variables ',' IDENTIFIER OF type	{

										$1.push({
											type: $5,
											title: $3,
											line: yylineno+1
										});

										$$ = $1;

									}

	
 | IDENTIFIER OF type  {

										placeholder_object_type = $3;
										placeholder_object_title = $1;

										$$ = [];
										$$.push({
											type: $3,
											title: $1,
											line: yylineno+1
										});	

									}


	|  IDENTIFIER OF IDENTIFIER  {

										$$ = [];
										$$.push({
											type: $3,
											title: $1,
											line: yylineno+1
										});	

									}

  

	
;
			
type: 

	INT 
| FLOAT
| STRING
| SYMB
| LOGIC
| TRUE
| FALSE
;


    

