// Simple logger implementation that works without external dependencies

const logLevels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4,
};

const colors = {
  error: '\x1b[31m', // red
  warn: '\x1b[33m',  // yellow
  info: '\x1b[32m',  // green
  http: '\x1b[35m',  // magenta
  debug: '\x1b[34m', // blue
  reset: '\x1b[0m',  // reset color
};

interface Logger {
  error: (message: string, ...meta: any[]) => void;
  warn: (message: string, ...meta: any[]) => void;
  info: (message: string, ...meta: any[]) => void;
  http: (message: string, ...meta: any[]) => void;
  debug: (message: string, ...meta: any[]) => void;
}

const createLogger = (): Logger => {
  const logLevel = process.env.LOG_LEVEL || 'info';
  const currentLogLevel = logLevels[logLevel as keyof typeof logLevels] ?? 2; // default to 'info'
  const isProduction = process.env.NODE_ENV === 'production';

  const getTimestamp = (): string => {
    return new Date().toISOString();
  };

  const log = (level: string, message: string, ...meta: any[]): void => {
    const timestamp = getTimestamp();
    const color = colors[level as keyof typeof colors] || '';
    const reset = colors.reset;
    
    const logMessage = `[${timestamp}] ${level.toUpperCase()}: ${message}`;
    
    if (meta.length > 0) {
      console.log(`${color}${logMessage}${reset}`, ...meta);
    } else {
      console.log(`${color}${logMessage}${reset}`);
    }
  };

  return {
    error: (message: string, ...meta: any[]) => {
      if (currentLogLevel >= logLevels.error) {
        log('error', message, ...meta);
      }
    },
    warn: (message: string, ...meta: any[]) => {
      if (currentLogLevel >= logLevels.warn) {
        log('warn', message, ...meta);
      }
    },
    info: (message: string, ...meta: any[]) => {
      if (currentLogLevel >= logLevels.info) {
        log('info', message, ...meta);
      }
    },
    http: (message: string, ...meta: any[]) => {
      if (currentLogLevel >= logLevels.http) {
        log('http', message, ...meta);
      }
    },
    debug: (message: string, ...meta: any[]) => {
      if (!isProduction && currentLogLevel >= logLevels.debug) {
        log('debug', message, ...meta);
      }
    },
  };
};

// Create and export logger instance
const logger = createLogger();

// Handle uncaught exceptions
process.on('uncaughtException', (error: Error) => {
  logger.error(`Uncaught Exception: ${error.message}`, error);
  // Consider whether to exit here based on the error
  // process.exit(1);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason: unknown) => {
  logger.error('Unhandled Rejection:', reason);
  // Consider whether to exit here based on the error
  // process.exit(1);
});

export default logger;