import mongoose, { Document, Schema, Types } from 'mongoose';

// Interface for Household document
export interface IHousehold extends Document {
  name: string;
  owner: Types.ObjectId;
  members: Types.ObjectId[];
  inviteCode: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

// Create schema
const householdSchema = new Schema<IHousehold>(
  {
    name: { 
      type: String, 
      required: true,
      trim: true,
      minlength: 1,
      maxlength: 100
    },
    owner: { 
      type: Schema.Types.ObjectId, 
      ref: 'User',
      required: true,
      index: true
    },
    members: [{
      type: Schema.Types.ObjectId,
      ref: 'User'
    }],
    inviteCode: {
      type: String,
      required: true,
      unique: true,
      index: true,
      minlength: 6,
      maxlength: 6
    },
    isActive: {
      type: Boolean,
      default: true
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

// Create index for invite code lookup
householdSchema.index({ inviteCode: 1 }, { unique: true });

// Create and export model
const Household = mongoose.model<IHousehold>('Household', householdSchema);

export { Household };
