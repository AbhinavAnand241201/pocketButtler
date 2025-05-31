import winston from 'winston';
import 'winston-daily-rotate-file';
import path from 'path';

const { combine, timestamp, printf, colorize, align } = winston.format;

const logDir = 'logs';

// Define log format
const logFormat = printf(({ level, message, timestamp, stack }) => {
  return `${timestamp} ${level}: ${stack || message}`;
});

// Define different colors for each level
const colors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'blue',
};

// Add colors to winston
winston.addColors(colors);

// Create the logger
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: combine(
    timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.errors({ stack: true }),
    winston.format.splat(),
    winston.format.json()
  ),
  defaultMeta: { service: 'pocket-butler-backend' },
  transports: [
    // Write all logs with level `error` and below to `error.log`
    new winston.transports.DailyRotateFile({
      filename: path.join(logDir, 'error-%DATE%.log'),
      level: 'error',
      maxSize: '20m',
      maxFiles: '14d',
    }),
    // Write all logs with level `info` and below to `combined.log`
    new winston.transports.DailyRotateFile({
      filename: path.join(logDir, 'combined-%DATE%.log'),
      maxSize: '20m',
      maxFiles: '14d',
    }),
  ],
  exitOnError: false, // Do not exit on handled exceptions
});

// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest })`
if (process.env.NODE_ENV !== 'production') {
  logger.add(
    new winston.transports.Console({
      format: combine(
        colorize({ all: true }),
        timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        align(),
        logFormat
      ),
    })
  );
}

export default logger;