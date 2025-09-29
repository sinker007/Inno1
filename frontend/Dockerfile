# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and yarn.lock to leverage Docker cache
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application's code
COPY . .


# Expose the port the app runs on
EXPOSE 3000

# Command to run the application in development mode to enable API proxying
CMD ["yarn", "dev"]