BLOCK-LEVEL ON ERROR UNDO, THROW.
USING Tokenizer.* FROM PROPATH.
USING Tokenizer.Interfaces.* FROM PROPATH.
/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.1.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @implements {Tokenizer.Interfaces.ITokenCollection} (src/Tokenizer/Interfaces/ITokenCollection.cls)
 * @implements {Tokenizer.Interfaces.ITokenCollectionIterable} (src/Tokenizer/Interfaces/ITokenCollectionIterable.cls)
 * @location src/Tokenizer/TokenCollection.cls
 * @description Implementation of ITokenCollection that manages a collection of tokens.
 * @versionHistory
 *      - 1.1.0: Added implementation of ITokenCollectionIterable interface.
 *      - 1.0.0: Initial implementation.
 * @changeLog
 *   - @version 1.1.0
 *      - [2025-11-21] - Implemented ITokenCollectionIterable interface methods.
 *   - @version 1.0.0
 *      - [2025-11-18] - Initial creation of TokenCollection class implementing ITokenCollection.
 * @codeExample
 ```abl
 USING Tokenizer.* FROM PROPATH. 
 USING Tokenizer.Interfaces.* FROM PROPATH. 
 // ... complementary code ...

 DEFINE VARIABLE tokens AS TokenCollection NO-UNDO.
 // ... populate tokens logic ...

 tokens:GetFirstToken().

 DO WHILE tokens:HasMoreTokens():
     DEFINE VARIABLE currentToken AS IToken NO-UNDO.
     ASSIGN
        currentToken = tokens:GetCurrentToken().

     // ... process currentToken as needed ...

     tokens:GetNextToken().
 END.
 ```
*/
CLASS Tokenizer.TokenCollection IMPLEMENTS ITokenCollection, ITokenCollectionIterable:
    /**
    * @tempTable ttTokens - Temporary table to store tokens.
    * @description Temporary table to hold tokens in the collection.
    * @noUndo
    * @fields
    *     - tokenIndex {INT64} - The index of the token in the collection.
    *     - tokenObject {Progress.Lang.Object} - The token object stored in the collection.
    * @indexes
    *     - idxTokenIndex {PRIMARY} - Primary index on tokenIndex field.
    * @changeLog
    *   - @version 1.0.0
    *     - [2025-11-18] - Added ttTokens temporary table.
    */
    DEFINE PRIVATE TEMP-TABLE ttTokens NO-UNDO
        FIELD tokenIndex AS INT64
        FIELD tokenObject AS Progress.Lang.Object
        INDEX idxTokenIndex IS PRIMARY tokenIndex.

    /**
    * @property TokenCount - The count of tokens in the collection.
    * @accessor PRIVATE GET, PRIVATE SET
    * @description Holds the number of tokens in the collection.
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Added TokenCount property.
    */
    DEFINE PRIVATE PROPERTY TokenCount AS INT64 NO-UNDO GET. SET.

    /**
    * @method GetFirstToken - Retrieves the first token in the collection.
    * @accessor PUBLIC
    * @description Returns the first token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The first token in the collection.
    * @changeLog
    *   - @version 1.1.0 
    *      - [2025-11-21] - Implemented GetFirstToken method.
    */
    METHOD PUBLIC IToken GetFirstToken():
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        FIND FIRST ttTokens NO-ERROR.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method GetNextToken - Retrieves the next token in the collection.
    * @accessor PUBLIC
    * @description Returns the next token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The next token in the collection.
    * @changeLog
    *   - @version 1.1.0
    *       - [2025-11-21] - Implemented GetNextToken method.
    */
    METHOD PUBLIC IToken GetNextToken():
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        FIND NEXT ttTokens NO-ERROR.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method GetPreviousToken - Retrieves the previous token in the collection.
    * @accessor PUBLIC
    * @description Returns the previous token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The previous token in the collection.
    * @changeLog
    *   - @version 1.1.0
    *      - [2025-11-21] - Implemented GetPreviousToken method.
    */
    METHOD PUBLIC IToken GetPreviousToken():
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        FIND PREV ttTokens NO-ERROR.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method GetLastToken - Retrieves the last token in the collection.
    * @accessor PUBLIC
    * @description Returns the last token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The last token in the collection.
    * @changeLog
    *   - @version 1.1.0
    *      - [2025-11-21] - Implemented GetLastToken method.
    */
    METHOD PUBLIC IToken GetLastToken():
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        FIND LAST ttTokens NO-ERROR.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method GetCurrentToken - Retrieves the current token in the iteration.
    * @accessor PUBLIC
    * @description Returns the current token in the iteration.
    * @returns {Tokenizer.Interfaces.IToken} - The current token in the iteration.
    * @changeLog
    *  - @version 1.1.0
    *    - [2025-11-21] - Implemented GetCurrentToken method.
    */
    METHOD PUBLIC IToken GetCurrentToken():
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method HasMoreTokens - Checks if there are more tokens in the collection.
    * @accessor PUBLIC
    * @description Returns TRUE if there are more tokens to iterate over, FALSE otherwise.
    * @returns {LOGICAL} - TRUE if more tokens are available, FALSE otherwise.
    * @changeLog
    *  - @version 1.1.0
    *       - [2025-11-21] - Implemented HasMoreTokens method.
    */
    METHOD PUBLIC LOGICAL HasMoreTokens():
        RETURN AVAILABLE ttTokens.
    END METHOD.

    /** 
    * @method AddToken - Adds a token to the collection.
    * @accessor PUBLIC
    * @description Adds the specified token to the collection.
    * @parameter {Tokenizer.Interfaces.IToken} pToken - The token to be added.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented AddToken method.
    */
    METHOD PUBLIC VOID AddToken(pToken AS IToken):
        CREATE ttTokens.
        ASSIGN 
            TokenCount = TokenCount + 1
            ttTokens.tokenIndex = TokenCount
            ttTokens.tokenObject = pToken.
    END METHOD.

    /**
    * @method GetTokenCount - Retrieves the number of tokens in the collection.
    * @accessor PUBLIC
    * @description Returns the total count of tokens in the collection.
    * @returns {INT64} - The number of tokens in the collection.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented GetTokenCount method.
    */
    METHOD PUBLIC INT64 GetTokenCount():
        RETURN TokenCount.
    END METHOD.

    /**
    * @method RemoveToken - Removes the token at the specified index.
    * @accessor PUBLIC
    * @description Removes the token located at the given index in the collection.
    * @parameter {INT64} pIndex - The index of the token to remove.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented RemoveToken method.
    */
    METHOD PUBLIC VOID RemoveToken(pIndex AS INT64):
        FIND FIRST ttTokens WHERE ttTokens.tokenIndex = pIndex NO-ERROR.
        IF AVAILABLE ttTokens THEN DO:
            DELETE ttTokens.

            ASSIGN 
                TokenCount = TokenCount - 1.

            FOR EACH ttTokens WHERE ttTokens.tokenIndex > pIndex:
                ASSIGN 
                    ttTokens.tokenIndex = ttTokens.tokenIndex - 1.
            END.
        END.
    END METHOD.

    /**
    * @method GetTokenAtIndex - Retrieves the token at the specified index.
    * @accessor PUBLIC
    * @description Returns the token located at the given index in the collection.
    * @parameter {INT64} pIndex - The index of the token to retrieve.
    * @returns {Tokenizer.Interfaces.IToken} - The token at the specified index.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-18] - Implemented GetTokenAtIndex method.
    */
    METHOD PUBLIC IToken GetTokenAtIndex(pIndex AS INT64):
        DEFINE VARIABLE resultToken AS IToken NO-UNDO.
        FIND FIRST ttTokens WHERE ttTokens.tokenIndex = pIndex NO-ERROR.
        IF AVAILABLE ttTokens THEN
            resultToken = CAST(ttTokens.tokenObject, IToken).
        RETURN resultToken.
    END METHOD.

    /**
    * @method GetTokensAsString - Returns a string representation of all tokens in the collection.
    * @accessor PUBLIC
    * @description Concatenates the string representations of all tokens in the collection.
    * @returns {LONGCHAR} - A long character string containing all tokens.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Implemented GetTokensAsString method.
    */
    METHOD PUBLIC LONGCHAR GetTokensAsString():
        DEFINE VARIABLE tokenStrings AS LONGCHAR NO-UNDO INITIAL "".
        DEFINE VARIABLE currentToken AS IToken NO-UNDO.
        DEFINE VARIABLE i AS INT64 NO-UNDO.

        DO i = 1 TO TokenCount:
            currentToken = GetTokenAtIndex(i).
            IF currentToken <> ? THEN DO:
                tokenStrings = tokenStrings + STRING(currentToken) + "~n".
            END.
        END.

        RETURN tokenStrings.
    END METHOD.

    /**
    * @method ToString - Returns a string representation of the token collection.
    * @accessor PUBLIC OVERRIDE
    * @description Provides a string representation of the token collection for debugging purposes.
    * @returns {CHARACTER} - A string representation of the token collection.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Implemented ToString method.
    */
    METHOD PUBLIC OVERRIDE CHARACTER ToString():
        RETURN SUBSTITUTE("TokenCollection(TokenCount: &1)", TokenCount). 
    END METHOD.

    /**
    * @destructor Cleans up the token collection.
    * @accessor PRIVATE
    * @description Destructor to clean up the token collection and free resources.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-21] - Implemented DESTRUCTOR method.
    */
    DESTRUCTOR TokenCollection():
        FOR EACH ttTokens:
            DELETE OBJECT ttTokens.tokenObject.
            DELETE ttTokens.
        END.
    END DESTRUCTOR.
END CLASS.
