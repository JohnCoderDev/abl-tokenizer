USING Tokenizer.Interfaces.* FROM PROPATH.
/**
 * @license MIT
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @author JohnCoderDev
 * @contributors 
 * @version 1.0.0
 * @location src/Tokenizer/Interfaces/ILexer.cls
 * @description Interface defining the contract for a lexer that tokenizes input based on token rules.
 * @versionHistory
 *     - 1.0.0: Initial definition of ILexer interface.
 * @changeLog
 *  - @version 1.0.0
 *      - [2025-11-15] - Created ILexer interface.
 */
INTERFACE Tokenizer.Interfaces.ILexer:
    /**
    * @property {Tokenizer.Interfaces.ITokenRules} TokenRules - The tokenization rules used by the lexer.
    * @accessor PUBLIC GET, PUBLIC SET
    * @description Holds the token rules for the lexer.
    * @noUndo
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added TokenRules property.
    */
    DEFINE PUBLIC PROPERTY TokenRules AS ITokenRules NO-UNDO GET. SET.

    /**
    * @method Tokenize - Tokenizes the given input string based on the defined token rules
    * @accessor PUBLIC
    * @description Processes the input string and returns a collection of tokens.
    * @parameter {LONGCHAR} pInput - The input string to be tokenized.
    * @returns {Tokenizer.Interfaces.ITokenCollection} - A collection of tokens extracted from the input.
    * @changeLog
    *   - @version 1.0.0
    *       - [2025-11-15] - Added Tokenize method.
    */
    METHOD PUBLIC ITokenCollection Tokenize(pInput AS LONGCHAR).
END INTERFACE.