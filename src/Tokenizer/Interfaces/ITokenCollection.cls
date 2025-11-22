USING Tokenizer.Interfaces.IToken FROM PROPATH.
/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.0.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @implements {Tokenizer.Interfaces.ITokenCollection} (src/Tokenizer/Interfaces/ITokenCollection.cls)
 * @location src/Tokenizer/TokenCollection.cls
 * @description Interface defining the contract for a collection of tokens.
 * @versionHistory
 *    - 1.0.0: Initial implementation.
 * @changeLog
 *   - @version 1.0.0
 *     - [2025-11-18] - Created ITokenCollection interface.
*/
INTERFACE Tokenizer.Interfaces.ITokenCollection:
    /**
    * @method AddToken - Adds a token to the collection.
    * @accessor PUBLIC
    * @description Adds the specified token to the collection.
    * @parameter {Tokenizer.Interfaces.IToken} pToken - The token to be added.
    * @changeLog
    *   - @version 1.0.0
    *      - [2025-11-18] - Added AddToken method.
    */
    METHOD PUBLIC VOID AddToken(pToken AS IToken).

    /**
    * @method GetTokenCount - Retrieves the number of tokens in the collection.
    * @accessor PUBLIC
    * @description Returns the total count of tokens in the collection.
    * @returns {INT64} - The number of tokens in the collection.
    * @changeLog
    *   - @version 1.0.0
    *     - [2025-11-18] - Added GetTokenCount method.
    */
    METHOD PUBLIC INT64 GetTokenCount().

    /**
    * @method GetTokenAtIndex - Retrieves the token at the specified index.
    * @accessor PUBLIC
    * @description Returns the token located at the given index in the collection.
    * @parameter {INT64} pIndex - The index of the token to retrieve.
    * @returns {Tokenizer.Interfaces.IToken} - The token at the specified index.
    * @changeLog
    *   - @version 1.0.0
    *     - [2025-11-18] - Added GetTokenAtIndex method.
    */
    METHOD PUBLIC IToken GetTokenAtIndex(pIndex AS INT64).
END INTERFACE.