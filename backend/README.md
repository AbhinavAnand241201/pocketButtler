# Pocket Butler Backend

This is the backend service for the Pocket Butler application, built with Node.js, Express, TypeScript, and MongoDB.

## Features

- User authentication with JWT
- Item management (CRUD operations)
- Household management
- Search functionality
- Input validation
- Error handling
- Logging
- Rate limiting
- Environment-based configuration

## Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher) or yarn
- MongoDB (v4.4 or higher)

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pocket-butler/backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Update the `.env` file with your configuration.

4. **Start the development server**
   ```bash
   npm run dev
   # or
   yarn dev
   ```

5. **Build for production**
   ```bash
   npm run build
   npm start
   # or
   yarn build
   yarn start
   ```

## Project Structure

```
src/
├── config/           # Configuration files
├── controllers/      # Route controllers
├── middleware/       # Express middlewares
├── models/           # Database models
├── routes/           # API routes
├── services/         # Business logic
├── utils/            # Utility functions
└── server.ts         # Application entry point
```

## API Documentation

API documentation is available at `/api-docs` when running in development mode.

## Testing

Run tests using:

```bash
npm test
# or
yarn test
```

## Linting

```bash
npm run lint
# or
yarn lint
```

## Environment Variables

See `.env.example` for a list of required environment variables.

## Deployment

1. Set up a MongoDB database (e.g., MongoDB Atlas)
2. Configure environment variables in your production environment
3. Build the application: `npm run build`
4. Start the server: `npm start`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
