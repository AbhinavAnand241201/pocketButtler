Here's a granular, step-by-step plan to build the Pocket Butler MVP backend with atomic, testable tasks. Each task includes GitHub push instructions:

### Phase 1: Core Infrastructure Setup
1. **Initialize backend repo**
   - `mkdir backend && cd backend`
   - `npm init -y`
   - `git add . && git commit -m "Initialize Node.js project"`
   - `git push origin main`

2. **Install core dependencies**
   - `npm install express mongoose dotenv jsonwebtoken`
   - `git add package*.json && git commit -m "Install core dependencies"`
   - `git push origin main`

3. **Create Express server skeleton**
   - Create `server.js`:
     ```javascript
     require('dotenv').config();
     const express = require('express');
     const app = express();
     const PORT = process.env.PORT || 3000;
     
     app.use(express.json());
     
     app.get('/', (req, res) => {
       res.send('Pocket Butler API');
     });
     
     app.listen(PORT, () => {
       console.log(`Server running on port ${PORT}`);
     });
     ```
   - `git add server.js && git commit -m "Add Express server skeleton"`
   - `git push origin main`

### Phase 2: Database & Models
4. **MongoDB connection setup**
   - Create `.env`:
     ```
     MONGODB_URI=mongodb://localhost:27017/pocketButler
     JWT_SECRET=your_secure_secret
     ```
   - Create `config/db.js`:
     ```javascript
     const mongoose = require('mongoose');
     
     const connectDB = async () => {
       try {
         await mongoose.connect(process.env.MONGODB_URI);
         console.log('MongoDB Connected');
       } catch (err) {
         console.error(err.message);
         process.exit(1);
       }
     };
     
     module.exports = connectDB;
     ```
   - Update `server.js` to call `connectDB()`
   - `git add .env config/db.js && git commit -m "MongoDB connection setup"`
   - `git push origin main`

5. **User model**
   - Create `models/User.js`:
     ```javascript
     const mongoose = require('mongoose');
     const bcrypt = require('bcryptjs');
     
     const userSchema = new mongoose.Schema({
       email: { type: String, required: true, unique: true },
       password: { type: String, required: true },
       name: { type: String, required: true },
       deviceToken: String,
       household: { type: mongoose.Schema.Types.ObjectId, ref: 'Household' }
     });
     
     userSchema.pre('save', async function(next) {
       if (this.isModified('password')) {
         this.password = await bcrypt.hash(this.password, 10);
       }
       next();
     });
     
     module.exports = mongoose.model('User', userSchema);
     ```
   - `git add models/User.js && git commit -m "Add User model"`
   - `git push origin main`

6. **Item model**
   - Create `models/Item.js`:
     ```javascript
     const mongoose = require('mongoose');
     
     const itemSchema = new mongoose.Schema({
       name: { type: String, required: true },
       location: { type: String, required: true },
       userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
       householdId: { type: mongoose.Schema.Types.ObjectId, ref: 'Household' },
       lastSeen: { type: Date, default: Date.now }
     }, { timestamps: true });
     
     module.exports = mongoose.model('Item', itemSchema);
     ```
   - `git add models/Item.js && git commit -m "Add Item model"`
   - `git push origin main`

### Phase 3: Authentication
7. **User registration endpoint**
   - Create `routes/auth.js`:
     ```javascript
     const express = require('express');
     const router = express.Router();
     const User = require('../models/User');
     const jwt = require('jsonwebtoken');
     
     router.post('/register', async (req, res) => {
       try {
         const { email, password, name } = req.body;
         const user = new User({ email, password, name });
         await user.save();
         res.status(201).json({ message: 'User created' });
       } catch (error) {
         res.status(400).json({ error: error.message });
       }
     });
     
     module.exports = router;
     ```
   - Register route in `server.js`
   - `git add routes/auth.js && git commit -m "User registration endpoint"`
   - `git push origin main`

8. **Login endpoint**
   - Add to `routes/auth.js`:
     ```javascript
     router.post('/login', async (req, res) => {
       try {
         const { email, password } = req.body;
         const user = await User.findOne({ email });
         if (!user) return res.status(401).json({ error: 'Invalid credentials' });
         
         const isMatch = await bcrypt.compare(password, user.password);
         if (!isMatch) return res.status(401).json({ error: 'Invalid credentials' });
         
         const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
         res.json({ token });
       } catch (error) {
         res.status(500).json({ error: error.message });
       }
     });
     ```
   - `git add routes/auth.js && git commit -m "Add login endpoint"`
   - `git push origin main`

### Phase 4: Item Management
9. **Create item endpoint**
   - Create `routes/items.js`:
     ```javascript
     const express = require('express');
     const router = express.Router();
     const Item = require('../models/Item');
     const auth = require('../middleware/auth');
     
     router.post('/', auth, async (req, res) => {
       try {
         const { name, location } = req.body;
         const item = new Item({ name, location, userId: req.user.userId });
         await item.save();
         res.status(201).json(item);
       } catch (error) {
         res.status(400).json({ error: error.message });
       }
     });
     
     module.exports = router;
     ```
   - `git add routes/items.js middleware/auth.js && git commit -m "Create item endpoint"`
   - `git push origin main`

10. **Get user items endpoint**
    - Add to `routes/items.js`:
      ```javascript
      router.get('/', auth, async (req, res) => {
        try {
          const items = await Item.find({ userId: req.user.userId });
          res.json(items);
        } catch (error) {
          res.status(500).json({ error: error.message });
        }
      });
      ```
    - `git add routes/items.js && git commit -m "Get user items endpoint"`
    - `git push origin main`

### Phase 5: Household Features
11. **Household model**
    - Create `models/Household.js`:
      ```javascript
      const mongoose = require('mongoose');
      
      const householdSchema = new mongoose.Schema({
        name: { type: String, required: true },
        members: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
        items: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Item' }]
      });
      
      module.exports = mongoose.model('Household', householdSchema);
      ```
    - `git add models/Household.js && git commit -m "Add Household model"`
    - `git push origin main`

12. **Household creation endpoint**
    - Create `routes/households.js`:
      ```javascript
      const express = require('express');
      const router = express.Router();
      const Household = require('../models/Household');
      const auth = require('../middleware/auth');
      
      router.post('/', auth, async (req, res) => {
        try {
          const household = new Household({ 
            name: req.body.name,
            members: [req.user.userId]
          });
          await household.save();
          res.status(201).json(household);
        } catch (error) {
          res.status(400).json({ error: error.message });
        }
      });
      
      module.exports = router;
      ```
    - `git add routes/households.js && git commit -m "Household creation endpoint"`
    - `git push origin main`

### Phase 6: Notification System
13. **Device token registration**
    - Add to `routes/auth.js`:
      ```javascript
      router.post('/device-token', auth, async (req, res) => {
        try {
          const user = await User.findById(req.user.userId);
          user.deviceToken = req.body.token;
          await user.save();
          res.json({ message: 'Device token updated' });
        } catch (error) {
          res.status(500).json({ error: error.message });
        }
      });
      ```
    - `git add routes/auth.js && git commit -m "Device token registration"`
    - `git push origin main`

14. **Geofencing trigger**
    - Create `services/notificationService.js`:
      ```javascript
      const apn = require('apn');
      
      const sendNotification = (deviceToken, message) => {
        const provider = new apn.Provider({
          token: {
            key: process.env.APNS_KEY_PATH,
            keyId: process.env.APNS_KEY_ID,
            teamId: process.env.APNS_TEAM_ID
          },
          production: false
        });
        
        const notification = new apn.Notification({
          alert: message,
          topic: 'com.yourdomain.pocketbutler'
        });
        
        provider.send(notification, deviceToken).then(result => {
          console.log('Notification sent:', result);
        });
      };
      
      module.exports = { sendNotification };
      ```
    - `git add services/notificationService.js && git commit -m "APNs notification service"`
    - `git push origin main`

### Phase 7: Integration & Testing
15. **API documentation**
    - Create `docs/API.md` with endpoint specifications
    - `git add docs/API.md && git commit -m "Add API documentation"`
    - `git push origin main`

16. **Docker setup**
    - Create `Dockerfile`:
      ```dockerfile
      FROM node:18-alpine
      WORKDIR /app
      COPY package*.json ./
      RUN npm install
      COPY . .
      EXPOSE 3000
      CMD ["node", "server.js"]
      ```
    - Create `docker-compose.yml`:
      ```yaml
      version: '3'
      services:
        backend:
          build: .
          ports:
            - "3000:3000"
          depends_on:
            - mongo
        mongo:
          image: mongo:latest
          ports:
            - "27017:27017"
      ```
    - `git add Dockerfile docker-compose.yml && git commit -m "Docker setup"`
    - `git push origin main`

### Testing Strategy:
1. After each commit, run:
   ```bash
   npm test # Add test scripts as you implement
   docker-compose up --build -d
   curl http://localhost:3000
   ```
2. Verify endpoints with Postman
3. Check MongoDB collections after operations
4. Test notification delivery using Apple Sandbox

### Critical Next Steps:
1. Implement rate limiting
2. Add input validation
3. Set up proper error handling
4. Implement CI/CD pipeline
5. Add test coverage

This granular approach allows the LLM to complete one atomic task at a time with immediate feedback loops. Each commit represents a testable unit of functionality that can be verified independently before proceeding.