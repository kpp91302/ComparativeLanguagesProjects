program Main(input, output);
var current_line : string; // global variable to hold the current line in the input stream
var next_token : string; // global variable to hold the next token in the input stream
var inputFile, outputFile : text; // global variable to hold the input line
var print_string : string; // global variable to hold the string to be printed

// function to append string to print_string
function append_string(s : string) : string;
begin
    print_string := print_string + s;
    append_string := print_string;
end;

// function to check if print_sting is equal to '    Input has invalid tokens.'
function check_if_invalid_token: boolean;
begin
    check_if_invalid_token := (print_string = '    Input has invalid tokens.');
end;

// function to check if print_sting is equal to '    Input is not a sentence.'
function check_if_not_sentence: boolean;
begin
    check_if_not_sentence := (print_string = '    Input is not a sentence.');
end;

// function to check if next_token is a valid token
function check_if_valid_token: boolean;
begin
    // compare token to all valid tokens
    if (next_token = 'lifted') or (next_token = 'saw') or (next_token = 'found') or
    (next_token = 'quickly') or (next_token = 'carefully') or (next_token = 'brilliantly') or
    (next_token = 'cow') or (next_token = 'alice') or (next_token = 'book') or
    (next_token = 'green') or (next_token = 'lean') or (next_token = 'mean') or
    (next_token = 'of') or (next_token = 'at') or (next_token = 'with') then
        check_if_valid_token := true
    else
        check_if_valid_token := false;
end;

//procedure to next token in the current input stream (line read from file)
procedure lexical(var line: string);
begin
    //skip whitespace
    while (line <> '') and (line[1] = ' ') do
        delete(line, 1, 1); //remove leading whitespace

    //check for remaining characters in the line
    if line <> '' then
    begin
        //get next token
        if pos(' ', line) > 0 then
        begin
        //set next_token to the next token in the line
        next_token := copy(line, 1, pos(' ', line) - 1);
        delete(line, 1, pos(' ', line)); //remove token from line
        end
        else
        begin
        //if there's no white spaces left, consume remaining characters
        next_token := line;
        line := ''; // clear the line
        end;
    end;
end;

procedure verb;
// <verb> --> lifted | saw | found
begin
    //check if next token is a valid verb
    if ((next_token = 'lifted') or (next_token = 'saw') or (next_token = 'found')) then
        begin
            append_string(next_token);
            lexical(current_line); {function written to advance to next token}
        end
    else
    begin
        // check to see if invalid sentence or invalid token
        if check_if_valid_token then
        begin
            print_string := '    Input is not a sentence.';
            exit;
        end
        else
        begin
        print_string := '    Input has invalid tokens.'; {function written to handle errors}
        exit;
        end;
    end;
end;

procedure adv;
// <adv> --> quickly | carefully | brilliantly
begin
    //check if next token is a valid adverb
    if ((next_token = 'quickly') or (next_token = 'carefully') or (next_token = 'brilliantly')) then
        begin
            append_string(next_token);
            lexical(current_line); {function written to advance to next token}
        end
    else
    begin
        // check to see if invalid sentence or invalid token
        if check_if_valid_token then
        begin
            print_string := '    Input is not a sentence.';
            exit;
        end
        else
        begin
        print_string := '    Input has invalid tokens.'; {function written to handle errors}
        exit;
        end;
    end;
end;

procedure noun;
// <noun> --> cow | alice | book
begin
    //check if next token is a valid noun
    if ((next_token = 'cow') or (next_token = 'alice') or (next_token = 'book')) then
        begin
            append_string(next_token);
            lexical(current_line); {function written to advance to next token}
        end
    else
    begin
        // check to see if invalid sentence or invalid token
        if check_if_valid_token then
        begin
            print_string := '    Input is not a sentence.';
            exit;
        end
        else
        begin
        print_string := '    Input has invalid tokens.'; {function written to handle errors}
        exit;
        end;
    end;
end;

procedure adj;  
// <adj> --> green | lean | mean
begin
    //check if next token is a valid adjective
    if ((next_token = 'green') or (next_token = 'lean') or (next_token = 'mean')) then
        begin
            append_string(next_token);
            lexical(current_line); {function written to advance to next token}
        end
    else
    begin
        // check to see if invalid sentence or invalid token
        if check_if_valid_token then
        begin
            print_string := '    Input is not a sentence.';
            exit;
        end
        else
        begin
        print_string := '    Input has invalid tokens.'; {function written to handle errors}
        exit;
        end;
    end;
end;

procedure prep;
// <prep> --> of | at | with
begin
    //check if next token is a valid preposition
    if ((next_token = 'of') or (next_token = 'at') or (next_token = 'with')) then
        begin
            append_string(next_token);
            lexical(current_line); {function written to advance to next token}
        end
    else
    begin
        // check to see if invalid sentence or invalid token
        if check_if_valid_token then
        begin
            print_string := '    Input is not a sentence.';
            exit;
        end
        else
        begin
        print_string := '    Input has invalid tokens.'; {function written to handle errors}
        exit;
        end;
    end;
end;

procedure verb_phrase;
// <verb_phrase> --> <verb> | <verb> <adv>
begin
    //parse first verb since either way it is required
    append_string('(');
    verb;
    // check if invalid token
    if check_if_invalid_token then
    begin
        exit;
    end;
    // check if invalid sentence
    if check_if_not_sentence then
    begin
        exit;
    end;
    //check if there is an valid adverb following the verb
    if ((next_token = 'quickly') or (next_token = 'carefully') or (next_token = 'brilliantly')) then
    begin
        append_string(' ');
        adv;
        // check if invalid token
        if check_if_invalid_token then
        begin
            exit;
        end;
        // check if invalid sentence
        if check_if_not_sentence then
        begin
            exit;
        end;
    end;
    append_string(')');
end;

procedure adj_phrase;
// <adj_phrase> --> <adj> | <adj> <adj_phrase>
begin
    //parse first adj since either way it is required
    adj;
    //check if invalid token
    if check_if_invalid_token then
    begin
        exit;
    end;
    if check_if_not_sentence then
    begin
        exit;
    end;
    //check if there is another adj following the first adj
    while ((next_token = 'green') or (next_token = 'lean') or (next_token = 'mean')) do
    begin
        append_string('(');
        adj;
        //check if invalid token
        if check_if_invalid_token then
        begin
            exit;
        end;
        if check_if_not_sentence then
        begin
            exit;
        end;
        append_string(')');
    end;
end;

//forward declare prep_phrase so that noun_phrase can call it
procedure prep_phrase; forward;
procedure noun_phrase;
// <noun_phrase> --> [<adj_phrase>] <noun> [<prep_phrase>]
//[] indicates that the token is optional, so we need to check if it is present
begin
    append_string('(');
    // check for optional adj_phrase by checking if next token is a valid adj
    if(next_token = 'green') or (next_token = 'lean') or (next_token = 'mean') then
    begin
        append_string('(');
        adj_phrase;
        // check if invalid token
        if check_if_invalid_token then
        begin
            exit;
        end;
        // check if invalid sentence
        if check_if_not_sentence then
        begin
            exit;
        end;
        append_string(')');
    end;
    //parse noun since it is required
    noun;
    // check if invalid token
    if check_if_invalid_token then
        exit;
    // check if invalid sentence
    if check_if_not_sentence then
        exit;
    //check for optional prep_phrase by checking if next token is a valid prep
    if(next_token = 'of') or (next_token = 'at') or (next_token = 'with') then
    begin
        append_string('(');
        prep_phrase;
        // check if invalid token
        if check_if_invalid_token then
        begin
            exit;
        end;
        // check if invalid sentence
        if check_if_not_sentence then
        begin
            exit;
        end;
        append_string(')');
    end;
    append_string(')');
end;

procedure prep_phrase;
// <prep_phrase> --> <prep> <noun_phrase>
begin
    //parse preposition
    prep;
    // check if invalid token
    if check_if_invalid_token then
    begin
        exit;
    end;
    // check if invalid sentence
    if check_if_not_sentence then
    begin
        exit;
    end;
    //parse noun_phrase
    noun_phrase;
    {no need to check for invalid token or
    invalid sentence since noun_phrase will handle it}
end;

procedure subject;
// <subject> --> <noun_phrase>
begin
    append_string('(');
    noun_phrase;
    // check if invalid token
    if check_if_invalid_token then
    begin
        exit;
    end;
    // check if invalid sentence
    if check_if_not_sentence then
    begin
        exit;
    end;
    append_string(')');
end;

procedure object_pro;
// <object> --> <noun_phrase>
begin
    append_string('(');
    noun_phrase;
    // check if invalid token
    if check_if_invalid_token then
    begin
        exit;
    end;
    // check if invalid sentence
    if check_if_not_sentence then
    begin
        exit;
    end;
    append_string(')');
end;

procedure sentence;
// <sentence> --> <subject> <verb_phrase> <object>
begin
    print_string := '';
    append_string('    (');

    //parse subject
    subject;

    // check for invalid token or invalid sentence and print accordingly
    if check_if_invalid_token then
    begin
        write(outputFile, print_string);
        writeln(outputFile, ''); // print newline
        // get rid of the rest of the line
        current_line := '';
        exit;
    end;
    if check_if_not_sentence then
    begin
        write(outputFile, print_string);
        writeln(outputFile, ''); // print newline
        current_line := '';
        exit;
    end;

    //check if there is a next non terminal
    if next_token <> '' then
    begin
        append_string(' ');
        verb_phrase;
        // check for invalid token or invalid sentence and print accordingly
        if check_if_invalid_token then
        begin
            write(outputFile, print_string);
            writeln(outputFile, ''); // print newline
            current_line := '';
            exit;
        end;
        if check_if_not_sentence then
        begin
            write(outputFile, print_string);
            writeln(outputFile, ''); // print newline
            current_line := '';
            exit;
        end;

        //check if there is a next non terminal
        if next_token <> '' then
        begin
            append_string(' ');
            object_pro;

            // check for invalid token or invalid sentence and print accordingly
            if check_if_invalid_token then
            begin
                write(outputFile, print_string);
                writeln(outputFile, ''); // print newline
                current_line := '';
                exit;
            end;
            if check_if_not_sentence then
            begin
                write(outputFile, print_string);
                writeln(outputFile, ''); // print newline
                current_line := '';
                exit;
            end;
        end
        // if there is no next non terminal, print invalid sentence
        else
        begin
            print_string := '    Input is not a sentence.';
        end;
    end
    // if there is no next non terminal, print invalid sentence
    else
    begin
        print_string := '    Input is not a sentence.';
    end;
    append_string(')');
    
    // print the string
    write(outputFile, print_string);
    writeln(outputFile, ''); // print newline
end;


// main program
begin
    //check for number of parameters
    if paramcount <> 2 then
    begin
        writeln('Usage: ./p1 <input file> <output file>');
        halt;
    end;

    //open input file
    assign(inputFile, paramstr(1));
    reset(inputFile);

    //open output file
    assign(outputFile, paramstr(2));
    rewrite(outputFile);

    while not eof(inputFile) do
    begin
    // read input line by line
    readln(inputFile, current_line);
    // recheck for eof
    if eof(inputFile) then
        break;
    // print input line
    write(outputFile, 'input-line => ', current_line, ' ');
    writeln(outputFile, ''); // print newline

    while current_line <> '' do
    begin
    lexical(current_line); // get next token
    sentence; // parse sentence
    end;

    // print newline
    write(outputFile);
    end;
    
    //close files
    close(inputFile);
    close(outputFile);
end.