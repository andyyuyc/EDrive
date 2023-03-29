import SwiftUI

struct ContentView: View {
    @ObservedObject var tripRecorder = TripRecorder()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(tripRecorder.distanceString)
                Spacer()
                Text(tripRecorder.timeString)
                Spacer()
                Text(tripRecorder.speedString)
                Spacer()
            }
            .font(.title)
            Spacer()
            Button(action: {
                self.tripRecorder.startRecording()
            }) {
                Text("Start")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            Button(action: {
                self.tripRecorder.stopRecording()
            }) {
                Text("Stop")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
