# COVID-19 Status

## Summary

The COVID-19 Status is an iOS app where you can check which pandemic controlling guidelines are taking place in your current location, using the traffic light system implemented by the German Government (Red, Yellow and Green, adding Dark Red for Bavaria). This system uses the cases/100k people of the last 7 days to present the current state.

  - `Green`: <35 cases/100k people
  - `Yellow`: <50 cases/100k people
  - `Red`: <100 cases/100k people
  - `Dark Red` _(Bavaria)_:  >100 cases/100k people

## Building

The build is pretty straightforward. The first time you open the project, you just have to wait Xcode to fetch the Alamofire package.

## Running

The app relies on the user's location to check for cases in their region, so it's important to mock your location correctly during running and testing. Fortunately Xcode makes it very easy to do it.

1. In Xcode, go to your top-left corner and click on your scheme
2. Click on `Edit Scheme...`
3. On the left-hand side list click on `Run` and then on `Options` the top right
4. On `Default Location` you can select from a list of places to mock

You can add locations to this list by simply adding an `.gpx` file on the project, like the `Berlin.gpx` and `Nuremberg.gpx` files

Now your app is ready to run with the selected location. It's recommended to use a real device, as the Simulator requires more steps to use the desired location on the current Xcode (12.2).

#### Simulator

After doing the steps presented above, the first time running on the Simulator you can click the Continue bottom button and grant access to the location.

But you still won't be able to access it. You still have to go to the Simulator's Maps app, open it and grant location access to it.

Then you can run the project again, it should get the Simulator's location normally.

## Test Background Fetch

The app uses `BGAppRefreshTaskRequest` to check for changes of phase while on Background and notifies the user by a local notification.

__To test it you must run it on a real device.__

1. You should run the app normally
2. Press the Home button to take it to the Background (to schedule `BGAppRefreshTaskRequest`)
3. Open it again from the Simulator's Home Screen
4. Pause the execution on Xcode
5. Run the following command on Xcode's terminal
```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.vinicius.fetchStatus"]
```
6. Resume the execution
7. Press again the Home button
8. After around 5 seconds the notification should be shown if the state has changed

To better test, you can remove the state change check on `func handleAppRefreshTask` to always show a notification whenever the check is made on the background.
