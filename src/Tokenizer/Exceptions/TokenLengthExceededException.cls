/**
 * @license MIT
 * @author JohnCoderDev
 * @version 1.0.0
 * @repository https://github.com/JohnCoderDev/abl-tokenizer
 * @contributors
 * @location src/Tokenizer/Exceptions/TokenLengthExceededException.cls
 * @description Exception thrown when a token exceeds the maximum allowed length.
 * @inherits Progress.Lang.AppError
 * @versionHistory
 *    - 1.0.0: Initial implementation.
 * @changeLog
 *  - @version 1.0.0
 *      - [2025-11-21] - Created TokenLengthExceededException class.
*/
CLASS Tokenizer.Exceptions.TokenLengthExceededException INHERITS Progress.Lang.AppError:
    /**
     * @constructor Initializes a new instance of the TokenLengthExceededException class.
     * @accessor PUBLIC
     * @description Constructor that sets the error message for the exception.
     * @parameter {CHARACTER} pMessage - The error message.
     * @changeLog
     *   - @version 1.0.0
     *      - [2025-11-21] - Implemented constructor.
    */
    CONSTRUCTOR TokenLengthExceededException(pMessage AS CHARACTER):
        SUPER(pMessage, -10).
    END CONSTRUCTOR.
END CLASS.