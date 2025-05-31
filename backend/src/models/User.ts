import mongoose, { Document, Schema, Model } from 'mongoose';
import bcrypt from 'bcryptjs';

// Interface for User document
interface IUser extends Document {
  email: string;
  password: string;
  name: string;
  deviceToken?: string;
  household?: mongoose.Types.ObjectId;
  comparePassword(candidatePassword: string): Promise<boolean>;
}

// Create schema
const userSchema = new Schema<IUser>(
  {
    email: { 
      type: String, 
      required: true, 
      unique: true,
      trim: true,
      lowercase: true,
      match: [/^\S+@\S+\.\S+$/, 'Please use a valid email address.']
    },
    password: { 
      type: String, 
      required: true,
      minlength: 8,
      select: false // Don't return password by default
    },
    name: { 
      type: String, 
      required: true,
      trim: true
    },
    deviceToken: {
      type: String,
      default: ''
    },
    household: {
      type: Schema.Types.ObjectId,
      ref: 'Household'
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: function(doc, ret) {
        delete ret.password; // Never return password
        delete ret.__v;
        return ret;
      }
    }
  }
);

// Hash password before saving
userSchema.pre<IUser>('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error: any) {
    next(error);
  }
});

// Method to compare passwords
userSchema.methods.comparePassword = async function(candidatePassword: string): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

// Create and export model
const User: Model<IUser> = mongoose.model<IUser>('User', userSchema);

export { IUser, User };
