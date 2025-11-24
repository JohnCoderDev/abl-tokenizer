BLOCK-LEVEL ON ERROR UNDO, THROW.
USING Tokenizer.* FROM PROPATH.
USING Tokenizer.Interfaces.* FROM PROPATH.
/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.0.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @implements {Tokenizer.Interfaces.ITokenRules} (src/Tokenizer/Interfaces/ITokenRules.cls)
 * @location src/Tokenizer/TokenRules.cls
 * @description Implementation of ITokenRules that defines tokenization rules.
 * @versionHistory
 *     - 1.0.0: Initial implementation.
 * @changeLog
 *   - @version 1.0.0
 *      - [2025-11-18] - Initial creation of TokenRules class implementing ITokenRules.
*/
CLASS Tokenizer.TokenRules IMPLEMENTS ITokenRules:
    /**
    * @tempTable ttTokenTypes - Temporary table to hold token types and their patterns.
    * @description Temporary table to hold token types and their patterns.
    * @noUndo
    * @fields
    *     - tokenType {CHARACTER} - The type of the token.
    *     - pattern {CHARACTER} - The pattern associated with the token type.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-18] - Added ttTokenTypes temporary table.
    */
    DEFINE PRIVATE TEMP-TABLE ttTokenTypes NO-UNDO
        FIELD tokenType AS CHARACTER
        FIELD pattern AS CHARACTER.

    /**
    * @tempTable ttRowSeparators - Temporary table to hold row separators.
    * @description Temporary table to hold row separators.
    * @noUndo
    * @fields
    *     - separator {CHARACTER} - The row separator character.
    * @indexes
    *     - idxSeparator {PRIMARY} - Primary index on separator field.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Added ttRowSeparators temporary table.
    */
    DEFINE PRIVATE TEMP-TABLE ttRowSeparators NO-UNDO
        FIELD separator AS CHARACTER
        INDEX idxSeparator AS PRIMARY separator.
    
    /**
    * @tempTable ttWhitespacePatterns - Temporary table to hold whitespace patterns.
    * @description Temporary table to hold whitespace patterns.
    * @noUndo
    * @fields
    *     - pattern {CHARACTER} - The whitespace pattern.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Added ttWhitespacePatterns temporary table.
    */
    DEFINE PRIVATE TEMP-TABLE ttWhitespacePatterns NO-UNDO
        FIELD pattern AS CHARACTER.

    /**
    * @property {CHARACTER} EscapeCharacter - The character used to escape special characters in token patterns.
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Holds the escape character for token patterns.
    * @initial "\"
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-18] - Implemented EscapeCharacter property.
    */
    DEFINE PUBLIC PROPERTY EscapeCharacter AS CHARACTER INITIAL "\" NO-UNDO GET. SET. 

    /**
    * @property {CHARACTER} DefaultTokenType - The default token type to assign when no specific type matches.
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Holds the default token type.
    * @initial "UNKNOWN"
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Implemented DefaultTokenType property.
    */
    DEFINE PUBLIC PROPERTY DefaultTokenType AS CHARACTER INITIAL "UNKNOWN" NO-UNDO GET. SET.

    /**
    * @property {LOGICAL} CaseSensitive - Indicates whether token type matching is case sensitive
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Determines if token type matching is case sensitive.
    * @initial TRUE
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Implemented CaseSensitive property.
    */
    DEFINE PUBLIC PROPERTY CaseSensitive AS LOGICAL INITIAL TRUE NO-UNDO GET. SET.

    /**
    * @method AddTokenType - Adds a new token type with its associated pattern to the token rules.
    * @accessor PUBLIC
    * @description Registers a new token type and its pattern.
    * @parameter {CHARACTER} pTokenType - The type of the token to be added.
    * @parameter {CHARACTER} pPattern - The pattern associated with the token type.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-18] - Implemented AddTokenType method.
    */    
    METHOD PUBLIC VOID AddTokenType(pTokenType AS CHARACTER, pPattern AS CHARACTER):
        CREATE ttTokenTypes.
        ASSIGN
            ttTokenTypes.tokenType = pTokenType
            ttTokenTypes.pattern = pPattern.
    END METHOD.

    /**
    * @method GetTokenType - Retrieves the token type associated with a given pattern.
    * @accessor PUBLIC
    * @description Gets the token type for the specified pattern.    
    * @parameter {CHARACTER} pPattern - The pattern to find the token type for
    * @returns {CHARACTER} - The token type associated with the pattern. If multiple patterns match, returns an empty string.
    * @changeLog
    *  - @version 1.0.0
    *     - [2025-11-18] - Implemented GetTokenType method.
    *     - [2025-11-21] - Simplified logic to return the first matching token type.
    */
    METHOD PUBLIC CHARACTER GetTokenType(pPattern AS CHARACTER):
        DEFINE VARIABLE sensitivity AS CHARACTER NO-UNDO.

        IF CaseSensitive THEN
            sensitivity = "CASE-SENSITIVE".
        ELSE
            sensitivity = "CASE-INSENSITIVE".

        FOR FIRST ttTokenTypes NO-LOCK
        WHERE COMPARE(pPattern, "=", ttTokenTypes.pattern, sensitivity):
            RETURN ttTokenTypes.tokenType.
        END.

        RETURN "".
    END METHOD.

    /**
    * @method RemoveTokenType - Removes a token type from the token rules.
    * @accessor PUBLIC
    * @description Deletes the specified token type from the token rules.
    * @parameter {CHARACTER} pTokenType - The type of the token to be removed.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented RemoveTokenType method.
    */
    METHOD PUBLIC VOID RemoveTokenType(pTokenType AS CHARACTER):
        FIND FIRST ttTokenTypes WHERE ttTokenTypes.TokenType = pTokenType EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ttTokenTypes THEN
            DELETE ttTokenTypes.
    END METHOD.

    /**
    * @method AddRowSeparator - Adds a row separator to the tokenization rules.
    * @accessor PUBLIC
    * @description Adds a new row separator character to the tokenization rules.
    * @parameter {CHARACTER} pRowSeparator - The row separator character to be added.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented AddRowSeparator method.
    */
    METHOD PUBLIC VOID AddRowSeparator(pRowSeparator AS CHARACTER):
        IF NOT CAN-FIND(FIRST ttRowSeparators WHERE ttRowSeparators.separator = pRowSeparator NO-LOCK) THEN DO:
            CREATE ttRowSeparators.
            ASSIGN 
                ttRowSeparators.separator = pRowSeparator.
        END.
    END METHOD.

    /**
    * @method IsRowSeparator - Checks if a character is defined as a row separator.
    * @accessor PUBLIC
    * @description Determines if the given character is a row separator.
    * @parameter {CHARACTER} pPattern - The character to check.
    * @returns {LOGICAL} - TRUE if the character is a row separator, otherwise FALSE.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented IsRowSeparator method.
    */
    METHOD PUBLIC LOGICAL IsRowSeparator(pPattern AS CHARACTER):
        RETURN CAN-FIND(FIRST ttRowSeparators WHERE ttRowSeparators.separator = pPattern NO-LOCK).
    END METHOD.

    /**
    * @method AddWhitespacePattern - Adds a whitespace pattern to the tokenization rules.
    * @accessor PUBLIC
    * @description Adds a new whitespace pattern to the tokenization rules.
    * @parameter {CHARACTER} pWhitespacePattern - The whitespace pattern to add.
    * @changeLog
    *  - @version 1.0.0
    *    - [2025-11-21] - Implemented AddWhitespacePattern method. 
    */
    METHOD PUBLIC VOID AddWhitespacePattern(pWhitespacePattern AS CHARACTER):
        IF NOT CAN-FIND(FIRST ttWhitespacePatterns WHERE ttWhitespacePatterns.pattern = pWhitespacePattern NO-LOCK) THEN DO:
            CREATE ttWhitespacePatterns.
            ASSIGN 
                ttWhitespacePatterns.pattern = pWhitespacePattern.
        END.
    END METHOD.

    /**
    * @method IsWhitespacePattern - Checks if a pattern is defined as a whitespace pattern.
    * @accessor PUBLIC
    * @description Determines if the given pattern is a whitespace pattern.
    * @parameter {CHARACTER} pPattern - The pattern to check.
    * @returns {LOGICAL} - TRUE if the pattern is a whitespace pattern, otherwise FALSE.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Implemented IsWhitespacePattern method.
    */
    METHOD PUBLIC LOGICAL IsWhitespacePattern(pPattern AS CHARACTER):
        RETURN CAN-FIND(FIRST ttWhitespacePatterns WHERE ttWhitespacePatterns.pattern = pPattern NO-LOCK).
    END METHOD.

    /**
    * @method GetTokensDefinitionsAsString - Returns a string representation of all token types and their patterns defined in the token rules.
    * @accessor PUBLIC
    * @description Provides a concatenated string of all token types and their patterns.
    * @returns {LONGCHAR} - A long character string containing all token definitions.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Implemented GetTokensDefinitionsAsString method.
    */
    METHOD PUBLIC LONGCHAR GetTokensDefinitionsAsString():
        DEFINE VARIABLE patterns AS LONGCHAR NO-UNDO INITIAL "".
        FOR EACH ttTokenTypes NO-LOCK:
            IF patterns <> "" THEN
                patterns = patterns + "~n".

            ASSIGN
                patterns = patterns + SUBSTITUTE("Type: '&1', Pattern: '&2'", ttTokenTypes.TokenType, ttTokenTypes.pattern).
        END.
        RETURN patterns.
    END METHOD.

    /**
    * @method ToString - Returns a string representation of the token rules.
    * @accessor PUBLIC OVERRIDE
    * @description Provides a human-readable representation of the token rules for debugging purposes.
    * @returns {CHARACTER} - A string representation of the token rules.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Implemented ToString method.
    */
    METHOD PUBLIC OVERRIDE CHARACTER ToString():
        RETURN SUBSTITUTE(
            "TokenRules(EscapeCharacter='&1', DefaultTokenType='&2')",
            EscapeCharacter,
            DefaultTokenType
        ).
    END METHOD.

    /**
    * @destructor Cleans up temporary tables used in the TokenRules class.
    * @accessor PRIVATE
    * @description Destructor that deletes all entries in the temporary tables.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-21] - Implemented destructor to clean up temporary tables.
    */
    DESTRUCTOR TokenRules():
        FOR EACH ttTokenTypes:
            DELETE ttTokenTypes.
        END.

        FOR EACH ttRowSeparators:
            DELETE ttRowSeparators.
        END.

        FOR EACH ttWhitespacePatterns:
            DELETE ttWhitespacePatterns.
        END.
    END DESTRUCTOR.
END CLASS.