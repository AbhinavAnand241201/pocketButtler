import mongoose, { Document, Schema, Types } from 'mongoose';

// Interface for Item document
export interface IItem extends Document {
  name: string;
  location: string;
  userId: Types.ObjectId;
  householdId?: Types.ObjectId;
  lastSeen: Date;
  imageUrl?: string;
  notes?: string;
  category?: string;
  isFavorite: boolean;
  createdAt: Date;
  updatedAt: Date;
}

// Create schema
const itemSchema = new Schema<IItem>(
  {
    name: { 
      type: String, 
      required: true,
      trim: true,
      minlength: 1,
      maxlength: 100
    },
    location: { 
      type: String, 
      required: true,
      trim: true,
      minlength: 1,
      maxlength: 200
    },
    userId: { 
      type: Schema.Types.ObjectId, 
      ref: 'User',
      required: true,
      index: true
    },
    householdId: { 
      type: Schema.Types.ObjectId, 
      ref: 'Household',
      index: true
    },
    imageUrl: {
      type: String,
      trim: true
    },
    notes: {
      type: String,
      trim: true,
      maxlength: 1000
    },
    category: {
      type: String,
      trim: true,
      maxlength: 50
    },
    isFavorite: {
      type: Boolean,
      default: false
    },
    lastSeen: {
      type: Date,
      default: Date.now
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: function(doc, ret) {
        ret.id = ret._id;
        delete ret._id;
        delete ret.__v;
        return ret;
      }
    }
  }
);

// Create text index for search functionality
itemSchema.index(
  { 
    name: 'text', 
    location: 'text',
    notes: 'text',
    category: 'text'
  },
  {
    weights: {
      name: 3,
      location: 2,
      category: 2,
      notes: 1
    },
    name: 'search_index'
  }
);

// Create and export model
const Item = mongoose.model<IItem>('Item', itemSchema);

export { Item };
