USING Tokenizer.Interfaces.IToken FROM PROPATH.
/**
 * @author JonhCoderDev
 * @version 1.0.0
 * @license MIT
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @location src/Tokenizer/Interfaces/ITokenCollectionIterable.cls
 * @description Interface defining the contract for iterable token collections.
 * @versionHistory
 *      - 1.1.0: Added GetCurrentToken method.
 *      - 1.0.0: Initial definition of ITokenCollectionIterable interface.
 * @changeLog
 *  - @version 1.1.0
 *     - [2025-11-21] - Added GetCurrentToken method.
 *  - @version 1.0.0
 *     - [2025-11-21] - Created ITokenCollectionIterable interface.
*/
INTERFACE Tokenizer.Interfaces.ITokenCollectionIterable PUBLIC.
    /**
    * @method GetFirstToken - Retrieves the first token in the collection.
    * @accessor PUBLIC
    * @description Returns the first token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The first token in the collection.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added GetFirstToken method.
    */
    METHOD PUBLIC IToken GetFirstToken().

    /**
    * @method GetNextToken - Retrieves the next token in the collection.
    * @accessor PUBLIC
    * @description Returns the next token from the token collection.
    * @returns {Tokenizer.Interfaces.IToken} - The next token in the collection.
    * @changeLog
    *  - @version 1.0.0
    *     - [2025-11-21] - Added GetNextToken method.
    */
    METHOD PUBLIC IToken GetNextToken().

    /**
     * @method GetPreviousToken - Retrieves the previous token in the collection.
     * @accessor PUBLIC
     * @description Returns the previous token from the token collection.
     * @returns {Tokenizer.Interfaces.IToken} - The previous token in the collection.
     * @changeLog
     *  - @version 1.0.0
     *   - [2025-11-21] - Added GetPreviousToken method.
    */
    METHOD PUBLIC IToken GetPreviousToken().

    /**
     * @method GetLastToken - Retrieves the last token in the collection.
     * @accessor PUBLIC
     * @description Returns the last token from the token collection.
     * @returns {Tokenizer.Interfaces.IToken} - The last token in the collection.
     * @changeLog
     *  - @version 1.0.0
     *    - [2025-11-21] - Added GetLastToken method.
    */
    METHOD PUBLIC IToken GetLastToken().

    /**
    * @method GetCurrentToken - Retrieves the current token in the iteration.
    * @accessor PUBLIC
    * @description Returns the current token in the iteration.
    * @returns {Tokenizer.Interfaces.IToken} - The current token in the iteration.
    * @changeLog
    *  - @version 1.1.0
    *    - [2025-11-21] - Added GetCurrentToken method.
    */
    METHOD PUBLIC IToken GetCurrentToken().

    /**
     * @method HasMoreTokens - Checks if there are more tokens in the collection.
     * @accessor PUBLIC
     * @description Returns TRUE if there are more tokens to iterate over, FALSE otherwise.
     * @returns {LOGICAL} - TRUE if more tokens are available, FALSE otherwise.
     * @changeLog
     *  - @version 1.0.0
     *    - [2025-11-21] - Added HasMoreTokens method.
    */
    METHOD PUBLIC LOGICAL HasMoreTokens().
END INTERFACE.