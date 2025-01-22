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

    @State var viewModel: EditAudioInfoViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    Image(systemName: .airpodsMax)
                        .scaledToFit()
                        .frame(width: geometry.size.width,
                               height: geometry.size.width)
                        .background(.gray.opacity(0.4))
                        .clipped()
                        .cornerRadius(Constants.cornerRadius)
                        .padding(.top, .paddingM)
                        .foregroundStyle(.pink)

                    HStack(spacing: 0) {
                        if let image = UIImage(contentsOfFile: viewModel.previewAudioData.authorAvatar) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                                .padding(.leading, 12)
                        } else {
                            Image(systemName: .userCircle)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                                .padding(.leading, 12)
                        }
                        VStack(alignment: .leading) {
                            Text(viewModel.previewAudioData.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 12)
                                .padding(.bottom, 6)
                                .foregroundStyle(.black)
                            Text(viewModel.previewAudioData.author)
                                .font(.subheadline)
                                .lineLimit(2)
                                .padding(.bottom, 8)
                                .foregroundStyle(.black)
                        }
                        .padding(.leading, 12)
                        Spacer()
                        Text(viewModel.previewAudioData.duration.toTimming)
                            .font(.subheadline)
                            .lineLimit(2)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.black)
                    }
                    .frame(minHeight: 60)
                    .background(.gray.opacity(0.4))
                    .cornerRadius(6)
                }
                Button {
                    viewModel.saveFile()
                } label: {
                    Text("Guardar".localized())
                        .foregroundStyle(.pink)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.4))
                        .cornerRadius(6)
                        .padding(.top, 12)
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
