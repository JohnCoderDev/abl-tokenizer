BLOCK-LEVEL ON ERROR UNDO, THROW.
USING Tokenizer.* FROM PROPATH.
USING Tokenizer.Interfaces.* FROM PROPATH.
/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.0.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors  
 * @implements {Tokenizer.Interfaces.ILexer} (src/Tokenizer/Interfaces/ILexer.cls)
 * @location src/Tokenizer/StringTokenizer.cls
 * @description Implementation of ILexer that tokenizes input based on provided token rules.
 * @versionHistory
 *     - 1.0.0: Initial implementation.
 * @changeLog
 *   - @version 1.0.0
 *      - [2025-11-15] - Initial creation of StringTokenizer class implementing ILexer.
 * @codeExample
 ```abl
 USING Tokenizer.* FROM PROPATH.

 DEFINE VARIABLE tokenRules AS TokenRules NO-UNDO.
 DEFINE VARIABLE lexer AS StringTokenizer NO-UNDO.
 DEFINE VARIABLE tokens AS TokenCollection NO-UNDO.

 tokenRules = NEW TokenRules().
 tokenRules:AddTokenType("COMMA", ",").
 tokenRules:AddTokenType("PERIOD", ".").
 tokenRules:AddWhiteSpacePattern(" ").
 tokenRules:DefaultTokenType = "WORD".
 tokenRules:CaseSensitive = FALSE.

 lexer = NEW StringTokenizer(tokenRules).
 tokens = CAST(lexer:Tokenize("Hello, world."), TokenCollection). 

 /*
    Resulting tokens:
        1. Type: WORD, Value: "Hello"
        2. Type: COMMA, Value: ","
        3. Type: WORD, Value: "world"
        4. Type: PERIOD, Value: "."
 */

 MESSAGE
        STRING(tokens:GetTokensAsString())
        VIEW-AS ALERT-BOX.
 
 DELETE OBJECT lexer.
 DELETE OBJECT tokenRules.
 DELETE OBJECT tokens.
 ```
*/
CLASS Tokenizer.StringTokenizer IMPLEMENTS ILexer:
    /**
     * @property {INT64} MaxTokenLength - The maximum length of a token.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Holds the maximum length for tokens.
     * @initial 31990
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-21] - Implemented MaxTokenLength property.
    */
    DEFINE PUBLIC PROPERTY MaxTokenLength AS INT64 NO-UNDO INITIAL 31990 GET. SET.

    /**
     * @property {Tokenizer.Interfaces.ITokenRules} TokenRules - The tokenization rules used by the lexer.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Holds the token rules for the lexer.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Added TokenRules property.
    */
    DEFINE PUBLIC PROPERTY TokenRules AS ITokenRules NO-UNDO GET. SET.

    /**
     * @constructor Initializes a new instance of the StringTokenizer class.
     * @accessor PUBLIC
     * @description Constructor that sets the token rules for the lexer.
     * @parameter {Tokenizer.Interfaces.ITokenRules} pTokenRules - The token rules to be used by the lexer.
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Implemented constructor.
    */
    CONSTRUCTOR StringTokenizer(pTokenRules AS ITokenRules):
        ASSIGN 
            TokenRules = pTokenRules.
    END CONSTRUCTOR.

    /**
     * @method Tokenize - Tokenizes the given input string based on the defined token rules.
     * @accessor PUBLIC
     * @description Processes the input string and returns a collection of tokens.
     * @parameter {LONGCHAR} pInput - The input string to be tokenized.
     * @returns {Tokenizer.Interfaces.ITokenCollection} - A collection of tokens extracted from the input.
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-17] - Implemented Tokenize method.
     *      - [2025-11-21] - Enhanced tokenization logic to handle escape characters and whitespace patterns.
    */
    METHOD PUBLIC ITokenCollection Tokenize(pInput AS LONGCHAR):
        DEFINE VARIABLE tokens AS ITokenCollection NO-UNDO.
        DEFINE VARIABLE tempToken AS Token NO-UNDO.
        DEFINE VARIABLE currentPosition AS INT64 NO-UNDO.
        DEFINE VARIABLE currentChar AS CHARACTER NO-UNDO.
        DEFINE VARIABLE accumulatedToken AS CHARACTER NO-UNDO INITIAL "".
        DEFINE VARIABLE inputLength AS INT64 NO-UNDO.
        DEFINE VARIABLE currentRow AS INT64 NO-UNDO INITIAL 1.
        DEFINE VARIABLE currentColumn AS INT64 NO-UNDO INITIAL 1.
        DEFINE VARIABLE tokenType AS CHARACTER NO-UNDO.
        DEFINE VARIABLE nextChar AS CHARACTER NO-UNDO.

        ASSIGN
            inputLength = LENGTH(pInput)
            tokens = NEW TokenCollection().

        DO currentPosition = 1 TO inputLength:
            ASSIGN 
                currentChar = SUBSTRING(pInput, currentPosition, 1).

            IF currentPosition < inputLength THEN
                ASSIGN 
                    nextChar = SUBSTRING(pInput, currentPosition + 1, 1).
            ELSE
                ASSIGN 
                    nextChar = "".
            
            IF TokenRules:IsRowSeparator(currentChar) THEN DO:
                IF LENGTH(accumulatedToken) > 0 THEN DO:
                    ASSIGN 
                        tokenType = TokenRules:GetTokenType(accumulatedToken).

                    IF tokenType = "" THEN
                        tokenType = TokenRules:DefaultTokenType.

                    ASSIGN
                        tempToken = NEW Token(tokenType, accumulatedToken, currentRow, currentColumn - LENGTH(accumulatedToken)).

                    tokens:AddToken(tempToken).

                    ASSIGN 
                        accumulatedToken = "".
                END.

                ASSIGN 
                    currentRow = currentRow + 1
                    currentColumn = 1.
            END.
            ELSE IF currentChar = TokenRules:EscapeCharacter THEN DO:
                IF currentPosition < inputLength THEN DO:
                    ASSIGN 
                        currentPosition = currentPosition + 1
                        currentChar = SUBSTRING(pInput, currentPosition, 1)
                        accumulatedToken = accumulatedToken + currentChar
                        currentColumn = currentColumn + 1.
                END.
            END.
            ELSE IF TokenRules:IsWhitespacePattern(currentChar) THEN DO:
                IF LENGTH(accumulatedToken) > 0 THEN DO:
                    ASSIGN 
                        tokenType = TokenRules:GetTokenType(accumulatedToken).

                    IF tokenType = "" THEN
                        tokenType = TokenRules:DefaultTokenType.

                    ASSIGN 
                        tempToken = NEW Token(tokenType, accumulatedToken, currentRow, currentColumn - LENGTH(accumulatedToken)).
                        
                    tokens:AddToken(tempToken).

                    ASSIGN 
                        accumulatedToken = "".
                    
                    IF TokenRules:GetTokenType(currentChar) <> "" THEN DO:
                        ASSIGN 
                            tokenType = TokenRules:GetTokenType(currentChar)
                            tempToken = NEW Token(tokenType, currentChar, currentRow, currentColumn).

                        tokens:AddToken(tempToken).
                    END.
                END.

                ASSIGN 
                    currentColumn = currentColumn + 1.
            END.
            ELSE IF TokenRules:GetTokenType(accumulatedToken + currentChar + nextChar) <> "" THEN DO:
                ASSIGN 
                    accumulatedToken = accumulatedToken + currentChar
                    currentColumn = currentColumn + 1.
            END.
            ELSE IF TokenRules:GetTokenType(accumulatedToken + currentChar) <> "" 
            AND TokenRules:IsWhitespacePattern(nextChar)
            THEN DO:
                ASSIGN 
                    accumulatedToken = accumulatedToken + currentChar
                    tokenType = TokenRules:GetTokenType(accumulatedToken)
                    tempToken = new Token(tokenType, accumulatedToken, currentRow, currentColumn - LENGTH(accumulatedToken)).

                tokens:AddToken(tempToken).

                ASSIGN 
                    accumulatedToken = ""
                    currentColumn = currentColumn + 1.
            END.
            ELSE IF TokenRules:GetTokenType(currentChar) <> "" THEN DO:
                IF LENGTH(accumulatedToken) > 0 THEN DO:
                    ASSIGN 
                        tokenType = TokenRules:GetTokenType(accumulatedToken).

                    IF tokenType = "" THEN
                        tokenType = TokenRules:DefaultTokenType.

                    ASSIGN
                        tempToken = new Token(tokenType, accumulatedToken, currentRow, currentColumn - LENGTH(accumulatedToken)).

                    tokens:AddToken(tempToken).
                    ASSIGN 
                        accumulatedToken = "".
                END.
                ASSIGN 
                    tokenType = TokenRules:GetTokenType(currentChar)
                    tempToken = new Token(tokenType, currentChar, currentRow, currentColumn).

                tokens:AddToken(tempToken).

                ASSIGN 
                    currentColumn = currentColumn + 1.
            END. 
            ELSE DO:
                ASSIGN 
                    accumulatedToken = accumulatedToken + currentChar
                    currentColumn = currentColumn + 1.
            END.
            IF LENGTH(accumulatedToken) >= MaxTokenLength THEN DO:
                UNDO, THROW NEW Tokenizer.Exceptions.TokenLengthExceededException(
                    "Token length exceeded the maximum limit of " + STRING(MaxTokenLength) + " characters."
                ).
            END.
        END.

        IF LENGTH(accumulatedToken) > 0 THEN DO:
            ASSIGN
                tokenType = TokenRules:GetTokenType(accumulatedToken).

            IF tokenType = "" THEN
                tokenType = TokenRules:DefaultTokenType.

            ASSIGN
                tempToken = new Token(tokenType, accumulatedToken, currentRow, currentColumn - LENGTH(accumulatedToken)).

            tokens:AddToken(tempToken).
        END.

        RETURN tokens.
    END METHOD.
END CLASS.
