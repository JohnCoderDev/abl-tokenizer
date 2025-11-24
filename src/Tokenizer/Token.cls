BLOCK-LEVEL ON ERROR UNDO, THROW.
USING Tokenizer.Interfaces.IToken FROM PROPATH.
/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.0.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @implements {Tokenizer.Interfaces.IToken} (src/Tokenizer/Interfaces/IToken.cls)
 * @location src/Tokenizer/Token.cls
 * @description Implementation of IToken representing a single token in the tokenization process.
 * @versionHistory
 *     - 1.0.0: Initial implementation.
 * @changeLog
 *   - @version 1.0.0
 *      - [2025-11-15] - Created Token class implementing IToken.
*/
CLASS Tokenizer.Token IMPLEMENTS IToken:
    /**
     * @property {CHARACTER} TokenType - The type of the token.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Represents the type/category of the token.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Added TokenType property.
    */
    DEFINE PUBLIC PROPERTY TokenType AS CHARACTER NO-UNDO GET. SET.
    /** 
     * @property {LONGCHAR} TokenValue - The value of the token.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description The actual string value of the token.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Added TokenValue property.
    */
    DEFINE PUBLIC PROPERTY TokenValue AS LONGCHAR NO-UNDO GET. SET.
    /**
     * @property {INT64} LineNumber - The line number where the token was found.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Indicates the line number in the input where the token appears.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Added LineNumber property.
    */
    DEFINE PUBLIC PROPERTY LineNumber AS INT64 NO-UNDO GET. SET.
    /**
     * @property {INT64} ColumnNumber - The column number where the token starts.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Indicates the column position in the line where the token starts.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-15] - Added ColumnNumber property.
    */
    DEFINE PUBLIC PROPERTY ColumnNumber AS INT64 NO-UNDO GET. SET.

    /**
     * @property {INT64} Length - The length of the token value.
     * @accessor PUBLIC GET, PUBLIC SET
     * @description Length of the token's value.
     * @noUndo
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-21] - Added Length property.
    */
    DEFINE PUBLIC PROPERTY Length AS INT64 NO-UNDO GET. SET.

    /**
     * @constructor Initializes a new instance of the Token class.
     * @accessor PUBLIC
     * @description Constructor that sets the properties of the token.
     * @parameter {CHARACTER} pTokenType - The type of the token.
     * @parameter {LONGCHAR} pTokenValue - The value of the token.
     * @parameter {INT64} pLineNumber - The line number where the token was found.
     * @parameter {INT64} pColumnNumber - The column number where the token starts.
     * @changeLog
     *   - @version 1.0.0
     *     - [2025-11-15] - Implemented constructor.
    */
    CONSTRUCTOR Token(
        pTokenType AS CHARACTER,
        pTokenValue AS LONGCHAR,
        pLineNumber AS INT64,
        pColumnNumber AS INT64
    ):
        ASSIGN
            TokenType = pTokenType
            TokenValue = pTokenValue
            LineNumber = pLineNumber
            ColumnNumber = pColumnNumber
            Length = LENGTH(pTokenValue).
    END CONSTRUCTOR.

    /**
    * @method ToString - Returns a string representation of the token.
    * @accessor PUBLIC OVERRIDE
    * @description Provides a human-readable representation of the token for debugging purposes.
    * @returns {CHARACTER} - A string representation of the token.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Implemented ToString method.
    */
    METHOD PUBLIC OVERRIDE CHARACTER ToString():
        DEFINE VARIABLE displayValue AS CHARACTER NO-UNDO.

        IF LENGTH(TokenValue) > 10 THEN
            displayValue = SUBSTRING(TokenValue, 1, 10) + "...".
        ELSE
            displayValue = TokenValue.

        RETURN SUBSTITUTE(
            "Token(Type: '&1', Value: '&2', Line: &3, Column: &4, Length: &5)",
            TokenType,
            displayValue,
            LineNumber,
            ColumnNumber, 
            Length
        ).
    END METHOD.
END CLASS.