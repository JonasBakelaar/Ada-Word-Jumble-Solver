-- Author: Jonas Bakelaar (0964977)
-- Date: March 4, 2018
-- Description: Program that takes a jumble of letters and prints out the anagrams of that jumble of letters based on the small dictionary provided with Linux
-- Sources: I used the algorithm at this link: https://www.geeksforgeeks.org/write-a-c-program-to-print-all-permutations-of-a-given-string/ 
--          This algorithm helped me find all the permutations of the letter jumble the user provides. Some additional modifications were required to use the algorithm in ADA. 
--          As a result this is not a direct copy of the code in the link, just a reference used to figure out how to get the permutations of a string efficiently.

with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.characters.handling; use ada.characters.handling;
procedure solveJumble is
    type permutations is array (1..720) of unbounded_string;
    type dictionaries is array (1..51244) of unbounded_string;
    confirmation: unbounded_string;
    userJumble: unbounded_string;
    permutationWords: permutations;
    dictionaryWords: dictionaries;
    
    procedure buildLEXICON(dictionaryWords: in out dictionaries) is
        infp : file_type;
        tempString: unbounded_string;
    begin
        open(infp,in_file,"/usr/share/dict/canadian-english-small");
        for i in 1..51244 loop
            exit when end_of_file(infp);
            get_line(infp, tempString);
            -- Put the string into the array of dictionary words
            dictionaryWords(i) := tempString;
        end loop;
        close(infp);
    end buildLEXICON;

    procedure inputJumble(userJumble: in out unbounded_string) is
        lowerCase1: string := " ";
        lowerCase2: string := "  ";
        lowerCase3: string := "   ";
        lowerCase4: string := "    ";
        lowerCase5: string := "     ";
        lowerCase6: string := "      ";
    begin

        Put_Line("Input a string of characters to find anagrams for.");
        get_line(userJumble);
        -- Converts the user jumble to lower case based on the length of the unbounded string.
        if length(userJumble) = 1 then
            lowerCase1 := To_String(userJumble);
            lowerCase1 := To_Lower(lowerCase1);
            userJumble := to_unbounded_string(lowerCase1);
        elsif length(userJumble) = 2 then
            lowerCase2 := To_String(userJumble);
            lowerCase2 := To_Lower(lowerCase2);
            userJumble := to_unbounded_string(lowerCase2);
        elsif length(userJumble) = 3 then
            lowerCase3 := To_String(userJumble);
            lowerCase3 := To_Lower(lowerCase3);
            userJumble := to_unbounded_string(lowerCase3);
        elsif length(userJumble) = 4 then
            lowerCase4 := To_String(userJumble);
            lowerCase4 := To_Lower(lowerCase4);
            userJumble := to_unbounded_string(lowerCase4);
        elsif length(userJumble) = 5 then
            lowerCase5 := To_String(userJumble);
            lowerCase5 := To_Lower(lowerCase5);
            userJumble := to_unbounded_string(lowerCase5);
        elsif length(userJumble) = 6 then
            lowerCase6 := To_String(userJumble);
            lowerCase6 := To_Lower(lowerCase6);
            userJumble := to_unbounded_string(lowerCase6);
        end if;
        
        -- If the length of the user string is greater than 6, set it to an empty string to avoid errors.
        if length(userJumble) > 6 then
            Put_Line("String must be a max length of 6!");
            userJumble := to_unbounded_string("");
        end if;

    end inputJumble;
   
    procedure swap(tempString: in out unbounded_string; i: in integer; j: in integer) is
        tempChar: character;
        tempChar2: character;
        k: integer := 0;
    begin
        --Swaps characters of a string based on locations provided
        tempChar := Element(tempString, i);
        tempChar2 := Element(tempString, j);
        replace_element(tempString, i, tempChar2);
        replace_element(tempString, j, tempChar);
    end swap;
    
    procedure permute(userJumble: in unbounded_string; start: in integer; finish: in integer; permutationWords: in out permutations; elementToAdd: in out integer) is
        tempString: unbounded_string;
        i: integer := 1;
        stringLength: integer := 0;
        sameFlag: integer := 0;
        tempPermutationString: unbounded_string;
    begin
        stringLength := length(userJumble);
        tempString := userJumble;
        if start = finish then
           -- Insert into the array of permutations
            for l in permutations'Range loop
                if permutationWords(l) = tempString then
                    sameFlag := 1;
                end if;
            end loop;
            if sameFlag = 0 then
                --Add it to the array
                permutationWords(elementToAdd) := tempString;
                elementToAdd := elementToAdd + 1;
            end if;
            sameFlag := 0;
        else
            -- Keep going with the recursion
            while i <= finish loop
                swap(tempString, start, i);
                permute(tempString, start+1, finish, permutationWords, elementToAdd);
                swap(tempString, start, i);
                i := i + 1;
            end loop;
        end if;
    end permute;

    procedure generateAnagram(userJumble: in unbounded_string; permutationWords: in out permutations) is
        stringLength: integer := 0;
        elementToAdd: integer := 1;
    begin
   
        if length(userJumble) < 1 then
            -- Do nothing
            Put_Line("No characters, no permutations!");
        else
            -- Get all permutations
            stringLength := length(userJumble);
            permute(userJumble, 1, stringLength, permutationWords, elementToAdd);
        end if;
        
    end generateAnagram;
    
    procedure findAnagram(permutationWords: in permutations; dictionaryWords: in dictionaries) is
    begin
        -- Loop through both arrays, finding words that are contained in both.
        put_line("Anagrams for this jumble:");
        for i in permutationWords'Range loop
            for j in dictionaryWords'Range loop
                if permutationWords(i) = dictionaryWords(j) then
                    put_line(permutationWords(i) & " ");
                end if;
            end loop;
        end loop;
    end findAnagram;
    
    procedure clearPermutations(permutationWords: in out permutations) is
        unboundedString: unbounded_string;
    begin
        -- Set each element of the permutation array with empty strings for when a user does multiple word jumbles
        unboundedString := to_unbounded_string("");
        for i in permutationWords'Range loop
            permutationWords(i) := unboundedString;
        end loop;
    end clearPermutations;

begin
 
    -- Call buildLEXICON, which will build the dictionary of words to find anagrams in and populate the array of dictionary words.
    buildLEXICON(dictionaryWords);
    
    loop
        -- Clear the permutations list with empty strings just in case...
        clearPermutations(permutationWords);
        
        -- Call the input function, which gets a user submitted string of letters.
        inputJumble(userJumble);
        
        -- Call generateAnagram, to generate the anagrams of the word.
        generateAnagram(userJumble, permutationWords);
        
        -- Use findAnagram in conjunction with the list of anagrams provided by generate anagram, search the dictionary array (also passed through the function), print results.
        findAnagram(permutationWords, dictionaryWords);
       
        -- Ask the user if they'd like to quit.
        Put_Line("Type Q to quit, or any other string to do another anagram.");
        get_line(confirmation);
        exit when confirmation = "Q";
    
    end loop;
    
end solveJumble;
