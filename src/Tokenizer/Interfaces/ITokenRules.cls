/**
 * @license MIT
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @author JohnCoderDev
 * @contributors  
 * @version 1.0.0
 * @location src/Tokenizer/Interfaces/ITokenRules.cls
 * @description Interface defining the contract for tokenization rules used by a lexer.
 * @versionHistory
 *     - 1.0.0: Initial definition of ITokenRules interface.
 * @changeLog
 *  - @version 1.0.0
 *      - [2025-11-15] - Created ITokenRules interface.
*/
INTERFACE Tokenizer.Interfaces.ITokenRules:
    /**
    * @property {CHARACTER} EscapeCharacter - The character used to escape special characters in token patterns.
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Holds the escape character for token patterns.
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added EscapeCharacter property.
    */
    DEFINE PUBLIC PROPERTY EscapeCharacter AS CHARACTER NO-UNDO GET. SET.

    /**
    * @property {CHARACTER} DefaultTokenType - The default token type to use when no specific type matches.
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Holds the default token type.
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Added DefaultTokenType property.
    */
    DEFINE PUBLIC PROPERTY DefaultTokenType AS CHARACTER NO-UNDO GET. SET.

    /**
    * @method AddTokenType - Adds a new token type with its associated pattern to the token rules.
    * @accessor PUBLIC
    * @description Registers a new token type and its pattern.
    * @parameter {CHARACTER} pTokenType - The type of the token to be added.
    * @parameter {CHARACTER} pPattern - The pattern associated with the token type.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added AddTokenType method.
    *       - [2025-11-21] - Change pPattern parameter type to CHARACTER.
    */
    METHOD PUBLIC VOID AddTokenType(pTokenType AS CHARACTER, pPattern AS CHARACTER).

    /**
    * @method GetTokenType - Retrieves the token type associated with a given pattern.
    * @accessor PUBLIC
    * @description Gets the token type for the specified pattern.
    * @parameter {CHARACTER} pPattern - The pattern to find the token type for.
    * @returns {CHARACTER} - The token type associated with the pattern.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added GetTokenType method.
    *       - [2025-11-21] - Change pPattern parameter type to CHARACTER.
    */
    METHOD PUBLIC CHARACTER GetTokenType(pPattern AS CHARACTER).

    /**
    * @method AddRowSeparator - Adds a row separator to the tokenization rules.
    * @accessor PUBLIC
    * @description Adds a new row separator character to the tokenization rules.
    * @parameter {CHARACTER} pRowSeparator - The row separator character to add.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-17] - Added AddRowSeparator method.
    */
    METHOD PUBLIC VOID AddRowSeparator(pRowSeparator AS CHARACTER).

    /**
    * @method IsRowSeparator - Checks if a character is defined as a row separator.
    * @accessor PUBLIC
    * @description Determines if the given character is a row separator.
    * @parameter {CHARACTER} pPattern - The character to check.
    * @returns {LOGICAL} - TRUE if the character is a row separator, otherwise FALSE.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-17] - Added IsRowSeparator method.
    */
    METHOD PUBLIC LOGICAL IsRowSeparator(pPattern AS CHARACTER).

    /**
    * @method AddWhitespacePattern - Adds a whitespace pattern to the tokenization rules.
    * @accessor PUBLIC
    * @description Adds a new whitespace pattern to the tokenization rules.
    * @parameter {CHARACTER} pWhitespacePattern - The whitespace pattern to add.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Added AddWhitespacePattern method. 
    */
    METHOD PUBLIC VOID AddWhitespacePattern(pWhitespacePattern AS CHARACTER).

    /**
    * @method IsWhitespacePattern - Checks if a pattern is defined as a whitespace pattern.
    * @accessor PUBLIC
    * @description Determines if the given pattern is a whitespace pattern.
    * @parameter {CHARACTER} pPattern - The pattern to check.
    * @returns {LOGICAL} - TRUE if the pattern is a whitespace pattern, otherwise FALSE.
    * @changeLog 
    *   - @version 1.0.0
    *       - [2025-11-21] - Added IsWhitespacePattern method.
    */
    METHOD PUBLIC LOGICAL IsWhitespacePattern(pPattern AS CHARACTER).
END INTERFACE.