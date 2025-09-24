# Campus Feast Backend API

A Node.js Express API server with MySQL database for the Campus Feast Flutter mobile app.

## Features

- **Authentication**: JWT-based user authentication and authorization
- **User Management**: Student, staff, vendor, and admin user types
- **Vendor Management**: CRUD operations for food vendors
- **Menu Management**: Menu items with categories, pricing, and discounts
- **Order Management**: Complete order lifecycle from placement to completion
- **Wallet System**: Digital wallet with transaction history
- **Security**: Rate limiting, CORS, input validation, and SQL injection protection

## Quick Start

### Prerequisites

- Node.js (v16 or higher)
- MySQL (v8.0 or higher)
- npm or yarn

### Installation

1. **Clone and navigate to backend directory**
   \`\`\`bash
   cd backend
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   npm install
   \`\`\`

3. **Set up environment variables**
   \`\`\`bash
   cp .env.example .env
   # Edit .env with your database credentials and JWT secret
   \`\`\`

4. **Set up MySQL database**
   \`\`\`bash
   # Create database and tables
   mysql -u root -p < database/schema.sql
   
   # Insert sample data
   mysql -u root -p < database/seed_data.sql
   \`\`\`

5. **Start the server**
   \`\`\`bash
   # Development mode with auto-reload
   npm run dev
   
   # Production mode
   npm start
   \`\`\`

The API will be available at `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get current user profile

### Vendors
- `GET /api/vendors` - Get all vendors
- `GET /api/vendors/:id` - Get vendor by ID
- `GET /api/vendors/:id/menu` - Get vendor menu items

### Orders
- `POST /api/orders` - Create new order
- `GET /api/orders/my-orders` - Get user's orders
- `PATCH /api/orders/:id/status` - Update order status (vendor/admin only)

### Wallet
- `GET /api/wallet/balance` - Get wallet balance
- `GET /api/wallet/transactions` - Get transaction history
- `POST /api/wallet/add-money` - Add money to wallet

## Database Schema

The MySQL database includes the following main tables:
- `users` - User accounts and profiles
- `vendors` - Food vendor information
- `menu_items` - Menu items for each vendor
- `orders` - Order records
- `order_items` - Individual items in each order
- `transactions` - Wallet transaction history
- `reviews` - User reviews for vendors
- `pickup_slots` - Available pickup time slots
- `discounts` - Vendor discount offers

## Security Features

- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: bcrypt for secure password storage
- **Rate Limiting**: Prevents API abuse
- **Input Validation**: Joi schema validation
- **SQL Injection Protection**: Parameterized queries
- **CORS Configuration**: Configurable cross-origin requests

## Environment Variables

\`\`\`env
# Database Configuration
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=campus_feast
DB_PORT=3306

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRES_IN=7d

# Server Configuration
PORT=3000
NODE_ENV=development
\`\`\`

## Testing

Test the API endpoints using tools like Postman or curl:

\`\`\`bash
# Health check
curl http://localhost:3000/health

# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@campus.edu","phone":"9876543210","campusId":"CS2024001","password":"password123"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@campus.edu","password":"password123"}'
\`\`\`

## Production Deployment

1. Set `NODE_ENV=production` in your environment
2. Use a process manager like PM2
3. Set up SSL/TLS certificates
4. Configure a reverse proxy (nginx)
5. Set up database backups
6. Monitor logs and performance

## Support

For issues and questions, please check the API documentation or contact the development team.
