# Set the base image to the official Flutter image
FROM google/dart:latest as builder

# Set the working directory to the root of the project
WORKDIR /app

# Copy the pubspec.* files to the container and get dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy the rest of the project to the container
COPY . .

# Build the Flutter app for release
RUN dart pub run build_runner build --delete-conflicting-outputs && \
    dart compile exe bin/main.dart -o /app/app

# Set the base image to a minimal Dart runtime image
FROM google/dart:slim

# Copy the Flutter app from the builder image
COPY --from=builder /app/app /app

# Set the working directory to the root of the app
WORKDIR /app

# Expose the default Flutter port
EXPOSE 8080

# Start the Flutter app
CMD ["/app/app"]

