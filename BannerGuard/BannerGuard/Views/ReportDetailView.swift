import SwiftUI
import MapKit

struct ReportDetailView: View {
    @StateObject private var vm: ReportDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(report: Report) {
        _vm = StateObject(wrappedValue: ReportDetailViewModel(report: report))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(vm.report.title)
                        .font(.title.bold())
                    
                    HStack {
                        Text(vm.report.status.capitalized)
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(statusBackground)
                            .foregroundStyle(statusColor)
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text(vm.report.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                MapView(selectedCoordinate: .constant(CLLocationCoordinate2D(latitude: vm.report.latitude, longitude: vm.report.longitude)))
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                if !vm.report.photoUrls.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Evidence Photos")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(vm.report.photoUrls, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                }
                
                if vm.report.status.lowercased() == "pending" {
                    Divider()
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Update Report")
                            .font(.headline)
                        
                        TextField("Update Title", text: $vm.editedTitle)
                            .textFieldStyle(.roundedBorder)
                        
                        TextEditor(text: $vm.editedDescription)
                            .frame(minHeight: 120)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.3), lineWidth: 1))
                        
                        Button("Save Updates") {
                            Task {
                                await vm.saveUpdates()
                                dismiss()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Report Details")
        .alert("Success", isPresented: $vm.showSuccess) {
            Button("OK") { }
        } message: {
            Text("Report updated successfully.")
        }
    }
    
    private var statusBackground: Color { vm.report.status.lowercased() == "resolved" ? .green.opacity(0.2) : .orange.opacity(0.2) }
    private var statusColor: Color { vm.report.status.lowercased() == "resolved" ? .green : .orange }
}