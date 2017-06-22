## The fruit basket
### Accessing the already compiled version
The compiled version of the app can be seen in the `dist` directory. It has an index.html file, which contains the app

### Development
To make changes to the app, you must install dependencies by running `yarn`.

After that `npm start` will run the watchers, and run the app with Hot Module Replacement enabled. Thus it is possible to modify the logic of the app - without even losing the state.

### Time Travel
While in development mode, it is also possible to do time travel, and explore the previous states, by using the panel on the bottom right corner.

### Unit tests
I was hoping to write some randomly generated Fuzz tests for the application, however I didn't have enough spare time for that.

To prove that the app works - there is at least 1 unit test that proves adding items to the cart is possible.
To run tests, use `npm t`.