program SentenceParser;

var
  inputFileName, outputFileName: string;
  inputFile, outputFile: Text;
  next_token: string; // Placeholder for the global variable
  next_token_type: string; // Placeholder for the function return type

procedure error(message: string);
begin
  writeln(message);
  halt;
end;

procedure lexical;
var
  inputLine: string;
  spacePos: Integer;
begin
  if not eof(inputFile) then
  begin
    readln(inputFile, inputLine);
    // Simple tokenization assuming space-separated words
    spacePos := Pos(' ', inputLine);
    if spacePos > 0 then
      next_token := Copy(inputLine, 1, spacePos - 1)
    else
      next_token := inputLine;
  end
  else
    error('Unexpected end of input');
end;


procedure adj;
begin
  write('(');
  if (next_token = 'green') or (next_token = 'lean') or (next_token = 'mean') then
  begin
    lexical;
    write(')');
  end
  else
    error('Input is not a sentence');
end;

procedure adj_phrase;
begin
  adj;
  if next_token_type = 'adj' then
    adj_phrase;
end;

procedure prep;
begin
  write('(');
  if (next_token = 'of') or (next_token = 'at') or (next_token = 'with') then
  begin
    lexical;
    write(')');
  end
  else
    error('Input is not a sentence');
end;

procedure noun;
begin
  write('(');
  if (next_token = 'cow') or (next_token = 'alice') or (next_token = 'book') then
  begin
    lexical;
    write(')');
  end
  else
    error('Input is not a sentence');
end;

procedure noun_phrase;
begin
  adj_phrase;
  noun;
  if next_token_type = 'prep' then
  begin
    prep;
    noun_phrase;
  end;
end;

procedure verb;
begin
  write('(');
  if (next_token = 'lifted') or (next_token = 'saw') or (next_token = 'found') then
  begin
    lexical;
    write(')');
  end
  else
    error('Input is not a sentence');
end;

procedure adv;
begin
  write('(');
  if (next_token = 'quickly') or (next_token = 'carefully') or (next_token = 'brilliantly') then
  begin
    lexical;
    write(')');
  end
  else
    error('Input is not a sentence');
end;

procedure verb_phrase;
begin
  verb;
  if next_token_type = 'adv' then
    adv;
end;

procedure subject;
begin
  noun_phrase;
end;

procedure object_;
begin
  noun_phrase;
end;

procedure sentence;
begin
  subject;
  verb_phrase;
  object_;
end;

begin
  if ParamCount <> 2 then
    error('Usage: SentenceParser <input_file> <output_file>');

  inputFileName := ParamStr(1);
  outputFileName := ParamStr(2);

  Assign(inputFile, inputFileName);
  Reset(inputFile);

  Assign(outputFile, outputFileName);
  Rewrite(outputFile);

  while not eof(inputFile) do
  begin
    sentence;
    writeln(outputFile);
  end;

  Close(inputFile);
  Close(outputFile);
end.
