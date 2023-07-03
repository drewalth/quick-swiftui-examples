import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}

// MARK: Using State

struct UsingStateView: View {
    @State private var count = 0
    
    var body: some View {
        Button("Clicked \(count) times") {
            count += 1
        }.buttonStyle(.borderedProminent)
        .padding()
    }
}

struct UsingStateView_Previews: PreviewProvider {
    static var previews: some View {
        UsingStateView()
    }
}

// MARK: Capture Form Input

struct CaptureFormInputView: View {
    @State private var inputValue = ""
    @State private var selectedOption: SelectOptions = .one
    
    var body: some View {
        VStack {
            VStack {
                Text("Submitted text")
                    .font(.title)
                Text(inputValue)
            }
            TextField("Enter text", text: $inputValue)
                .padding()
                .padding(.bottom, 24)
            VStack {
                Text("Selected option")
                Text(selectedOption.rawValue)
            }
            Picker("Select option", selection: $selectedOption) {
                ForEach(SelectOptions.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }.padding()
    }
    
    enum SelectOptions: String, CaseIterable {
        case one, two, three, four
    }
}

struct CaptureFormInputView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureFormInputView()
    }
}

// MARK: Passing Callback Functions

struct ParentView: View {
    @State private var sheetVisible = false
    var body: some View {
        Button("open sheet", action: {
            sheetVisible.toggle()
        }) 
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $sheetVisible, onDismiss: nil) {
                ChildView(onCancel: {
                    sheetVisible = false
                }, onSubmit: { email in
                    print(email)
                    sheetVisible = false
                })
            }
    }
}

struct ChildView: View {
    let onCancel: () -> Void
    let onSubmit: (String) -> Void
    
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Some form modal")
                TextField("Email", text: $email)
            }.padding(24)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("cancel", action: onCancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Submit") {
                            onSubmit(email)
                        }
                    }
                }
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
            .previewDisplayName("Passing callbacks")
    }
}

// MARK: Sharing data

class AppData: ObservableObject {
    @Published var message = "Hello from AppData"
}

struct SharingAppDataView: View {
    @StateObject var appData = AppData()
    var body: some View {
        OneView()
            .environmentObject(appData)
    }
}

struct OneView: View {
    var body: some View {
        
        VStack {
            Text("one view")
            TwoView()
        }.padding()
            .border(.gray, width: 2)
    }
}

struct TwoView: View {
    var body: some View {
        VStack {
            Text("two view")
            ThreeView()
        }.padding()
            .border(.gray, width: 2)
    }
}

struct ThreeView: View {
    
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
       VStack {
            Text("three view")
           Text("AppData Message: \(appData.message)")
       }
            .padding()
            .border(.gray, width: 2)
    }
}

struct SharingAppDataView_Previews: PreviewProvider {
    static var previews: some View {
        SharingAppDataView()
    }
}

// MARK: Side effects

struct SideEffectsView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                print("View appeared")
            }
            .onDisappear {
                print("View disappeared")
            }
            .task {
                do {
                    try await fetchRemoteData()
                } catch {
                    print(error)
                }
            }
    }
    
    private func fetchRemoteData() async throws {
        print("make that http call")
    }
    
}

struct SideEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        SideEffectsView()
    }
}
