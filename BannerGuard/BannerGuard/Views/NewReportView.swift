import SwiftUI
import MapKit

struct NewReportView: View {
    @StateObject private var vm = NewReportViewModel()
    @State private var showPicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    MapView(selectedCoordinate: $vm.coordinate)
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Section("Banner Details") {
                    TextField("Title / Short Description", text: $vm.title)
                    TextEditor(text: $vm.description)
                        .frame(minHeight: 100)
                }
                
                Section("Evidence Photo") {
                    if let image = vm.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        sourceType = .camera
                        showPicker = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                    }
                    
                    Button {
                        sourceType = .photoLibrary
                        showPicker = true
                    } label: {
                        Label("Choose from Library", systemImage: "photo.on.rectangle")
                    }
                }
            }
            .navigationTitle("New Report")
            .toolbar {
                Button("Submit") {
                    Task { await vm.submit() }
                }
                .disabled(vm.title.isEmpty || vm.coordinate == nil)
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $vm.selectedImage)
            }
        }
    }
}