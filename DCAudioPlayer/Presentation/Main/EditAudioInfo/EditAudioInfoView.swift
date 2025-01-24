//
//  EditAudioInfoView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//  
//

import SwiftUI

struct EditAudioInfoView: View {

    private enum Constants {
        static let cornerRadius: CGFloat = 8
    }

    @Environment(\.dismiss) var dismiss
    @State var viewModel: EditAudioInfoViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    EditableImage(imageStyle: .square) { _ in
                        // TODO: Save image
                    }
                    .frame(width: geometry.size.width,
                           height: geometry.size.width)
                    .cornerRadius(Constants.cornerRadius)
                    .padding(.top, .paddingM)

                    HStack(spacing: 0) {
                        EditableImage(imageStyle: .circular) { _ in
                            // TODO: Save image
                        }
                        .frame(width: 60, height: 60)
                        .padding(.leading, 12)
                        VStack(alignment: .leading) {
                            TextField("Título".localized(),
                                      text: $viewModel.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 12)
                                .padding(.bottom, 6)
                                .foregroundStyle(.black)
                                .tint(.pink)
                            TextField("Autor".localized(),
                                      text: $viewModel.author)
                                .font(.subheadline)
                                .lineLimit(2)
                                .padding(.bottom, 8)
                                .foregroundStyle(.black)
                                .tint(.pink)
                        }
                        .padding(.leading, 12)
                        Spacer()
                        Text(viewModel.audioDuration.toTimming)
                            .font(.subheadline)
                            .lineLimit(2)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.black)
                    }
                    .frame(minHeight: 60)
                    .background(.gray.opacity(0.4))
                    .cornerRadius(6)
                    VStack {
                        HStack {
                            TextField(text: $viewModel.desc,
                                      axis: .vertical,
                                      label: {
                                Text("Descripción".localized())
                            })
                            .padding(12)
                            .tint(.pink)
                        }
                        Spacer()
                    }
                    .background(.gray.opacity(0.4))
                    .cornerRadius(6)
                    .frame(minHeight: 80)
                }
                Button {
                    viewModel.saveFile()
                    dismiss()
                } label: {
                    Text("Guardar".localized())
                        .foregroundStyle(.pink)
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.4))
                        .cornerRadius(6)
                        .padding(.vertical, 12)
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    let persistentContainer = SwiftDataContainer(isStoredInMemoryOnly: true)
    let database = AudioFileDatabase(databaseManager: persistentContainer)
    let repository = AudioFilesRepository(audioFilesDatabse: database)
    let useCase = AudioFileUseCase(repository: repository)
    EditAudioInfoViewBuilderMock().build(fileURL: URL(fileURLWithPath: "/path/to/file"),
                                         useCase: useCase)
}
