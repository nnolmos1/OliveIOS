//
//  Scan.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI
import PhotosUI

struct ScanMenuView: View {

    // MARK: - Scanner Mode

    private enum ScannerMode: String, CaseIterable {
        case scan = "Scan"
        case upload = "Upload"
        case paste = "Paste"
    }

    @StateObject private var cameraManager = CameraManager()

    @State private var selectedMode: ScannerMode = .scan
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var uploadedImage: UIImage?
    @State private var pastedMenuText = ""

    // The scan frame is stored as percentages of the camera preview.
    @State private var scanFrame = CGRect(
        x: 0.12,
        y: 0.16,
        width: 0.76,
        height: 0.55
    )

    var body: some View {
        VStack(spacing: 16) {
            modePicker

            Group {
                switch selectedMode {
                case .scan:
                    scannerContent

                case .upload:
                    uploadContent

                case .paste:
                    pasteContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(
            Color(red: 0.92, green: 0.88, blue: 0.79)
                .ignoresSafeArea()
        )
        .onAppear {
            if selectedMode == .scan {
                cameraManager.startSession()
            }
        }
        .onDisappear {
            cameraManager.stopSession()
        }
        .onChange(of: selectedMode) { _, newMode in
            if newMode == .scan {
                cameraManager.startSession()
            } else {
                cameraManager.stopSession()
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            loadPhoto(from: newItem)
        }
    }

    // MARK: - Mode Picker

    private var modePicker: some View {
        HStack(spacing: 0) {
            ForEach(ScannerMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedMode = mode
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(
                            selectedMode == mode ? Color.primary : Color.secondary
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background {
                            if selectedMode == mode {
                                Capsule()
                                    .fill(Color.white.opacity(0.95))
                                    .shadow(
                                        color: .black.opacity(0.12),
                                        radius: 3,
                                        y: 1
                                    )
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.08))
        )
    }

    // MARK: - Camera Scanner

    private var scannerContent: some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack {
                cameraBackground(size: size)

                if cameraManager.permissionGranted {
                    CameraPreview(session: cameraManager.session)
                        .frame(width: size.width, height: size.height)
                        .clipped()

                    ScanFrameOverlay(
                        normalizedFrame: $scanFrame,
                        containerSize: size
                    )

                    cameraControls
                } else {
                    permissionView
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
        }
    }

    @ViewBuilder
    private func cameraBackground(size: CGSize) -> some View {
        if let image = cameraManager.capturedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    capturedImageControls
                }
        } else {
            Color.black
        }
    }

    private var cameraControls: some View {
        VStack {
            Spacer()

            Text("Position menu in the frame")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.62))
                )
                .padding(.bottom, 24)

            ZStack {
                HStack {
                    Spacer()

                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 21, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(Color.black.opacity(0.55))
                            )
                    }
                }

                Button {
                    cameraManager.capturePhoto()
                    UIImpactFeedbackGenerator(style: .medium)
                        .impactOccurred()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 76, height: 76)

                        Circle()
                            .fill(Color.white)
                            .frame(width: 62, height: 62)
                    }
                }
                .buttonStyle(ShutterButtonStyle())
                .accessibilityLabel("Take menu photo")
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 22)
        }
    }

    private var capturedImageControls: some View {
        VStack {
            Spacer()

            HStack(spacing: 12) {
                Button {
                    cameraManager.capturedImage = nil
                    cameraManager.startSession()
                } label: {
                    Label("Retake", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ScannerActionButtonStyle(filled: false))

                Button {
                    guard let image = cameraManager.capturedImage else {
                        return
                    }

                    let croppedImage = MenuImageCropper.crop(
                        image: image,
                        to: scanFrame
                    )

                    uploadedImage = croppedImage
                    cameraManager.capturedImage = croppedImage

                    UIImpactFeedbackGenerator(style: .light)
                        .impactOccurred()

                } label: {
                    Label("Use Photo", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ScannerActionButtonStyle(filled: true))
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }

    private var permissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 42))
                .foregroundStyle(.white)

            Text("Camera Access Needed")
                .font(.headline)
                .foregroundStyle(.white)

            Text("Allow camera access in Settings to scan a restaurant menu.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.horizontal, 28)

            Button("Open Settings") {
                guard let settingsURL = URL(
                    string: UIApplication.openSettingsURLString
                ) else {
                    return
                }

                UIApplication.shared.open(settingsURL)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    // MARK: - Upload Mode

    private var uploadContent: some View {
        VStack(spacing: 22) {
            Spacer()

            if let uploadedImage {
                Image(uiImage: uploadedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 430)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.12), radius: 8)
            } else {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)

                Text("Upload a Menu")
                    .font(.title3.bold())

                Text("Choose a clear photo of a restaurant menu from your photo library.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images
            ) {
                Label(
                    uploadedImage == nil ? "Choose Photo" : "Choose Another",
                    systemImage: "photo.on.rectangle"
                )
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(Color.black)
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Paste Mode

    private var pasteContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Paste Menu Text")
                .font(.title3.bold())

            Text("Copy a restaurant menu from a website, then paste it below.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextEditor(text: $pastedMenuText)
                .font(.body)
                .padding(12)
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(alignment: .topLeading) {
                    if pastedMenuText.isEmpty {
                        Text("Paste menu items, descriptions, and prices here...")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 20)
                            .allowsHitTesting(false)
                    }
                }

            Button {
                /*
                 Send `pastedMenuText` to your menu parser here.
                 */
            } label: {
                Text("Analyze Menu")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                pastedMenuText.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                                ? Color.gray
                                : Color.black
                            )
                    )
            }
            .disabled(
                pastedMenuText.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            )
        }
    }

    // MARK: - Photo Loading

    private func loadPhoto(from item: PhotosPickerItem) {
        Task {
            do {
                guard let data = try await item.loadTransferable(
                    type: Data.self
                ),
                let image = UIImage(data: data) else {
                    return
                }

                await MainActor.run {
                    uploadedImage = image
                    cameraManager.capturedImage = nil
                    selectedMode = .upload
                }
            } catch {
                print("Unable to load selected photo: \(error)")
            }
        }
    }
}

// MARK: - Resizable Scan Frame

private struct ScanFrameOverlay: View {

    @Binding var normalizedFrame: CGRect
    let containerSize: CGSize

    private let minimumWidth: CGFloat = 130
    private let minimumHeight: CGFloat = 130
    private let handleSize: CGFloat = 42

    var body: some View {
        let frame = actualFrame

        ZStack {
            dimmedOutsideArea(frame: frame)

            cornerBrackets(frame: frame)

            resizeHandle(for: .topLeft, frame: frame)
            resizeHandle(for: .topRight, frame: frame)
            resizeHandle(for: .bottomLeft, frame: frame)
            resizeHandle(for: .bottomRight, frame: frame)
        }
    }

    private var actualFrame: CGRect {
        CGRect(
            x: normalizedFrame.minX * containerSize.width,
            y: normalizedFrame.minY * containerSize.height,
            width: normalizedFrame.width * containerSize.width,
            height: normalizedFrame.height * containerSize.height
        )
    }

    private func dimmedOutsideArea(frame: CGRect) -> some View {
        Path { path in
            path.addRect(
                CGRect(origin: .zero, size: containerSize)
            )
            path.addRoundedRect(
                in: frame,
                cornerSize: CGSize(width: 8, height: 8)
            )
        }
        .fill(
            Color.black.opacity(0.28),
            style: FillStyle(eoFill: true)
        )
        .allowsHitTesting(false)
    }

    private func cornerBrackets(frame: CGRect) -> some View {
        Path { path in
            let length: CGFloat = 30
            let radius: CGFloat = 3

            // Top-left
            path.move(to: CGPoint(x: frame.minX, y: frame.minY + length))
            path.addLine(to: CGPoint(x: frame.minX, y: frame.minY + radius))
            path.addQuadCurve(
                to: CGPoint(x: frame.minX + radius, y: frame.minY),
                control: CGPoint(x: frame.minX, y: frame.minY)
            )
            path.addLine(to: CGPoint(x: frame.minX + length, y: frame.minY))

            // Top-right
            path.move(to: CGPoint(x: frame.maxX - length, y: frame.minY))
            path.addLine(to: CGPoint(x: frame.maxX - radius, y: frame.minY))
            path.addQuadCurve(
                to: CGPoint(x: frame.maxX, y: frame.minY + radius),
                control: CGPoint(x: frame.maxX, y: frame.minY)
            )
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY + length))

            // Bottom-left
            path.move(to: CGPoint(x: frame.minX, y: frame.maxY - length))
            path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY - radius))
            path.addQuadCurve(
                to: CGPoint(x: frame.minX + radius, y: frame.maxY),
                control: CGPoint(x: frame.minX, y: frame.maxY)
            )
            path.addLine(to: CGPoint(x: frame.minX + length, y: frame.maxY))

            // Bottom-right
            path.move(to: CGPoint(x: frame.maxX - length, y: frame.maxY))
            path.addLine(to: CGPoint(x: frame.maxX - radius, y: frame.maxY))
            path.addQuadCurve(
                to: CGPoint(x: frame.maxX, y: frame.maxY - radius),
                control: CGPoint(x: frame.maxX, y: frame.maxY)
            )
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY - length))
        }
        .stroke(
            Color.white,
            style: StrokeStyle(
                lineWidth: 4,
                lineCap: .round,
                lineJoin: .round
            )
        )
        .shadow(color: .black.opacity(0.35), radius: 2)
        .allowsHitTesting(false)
    }

    private func resizeHandle(
        for corner: FrameCorner,
        frame: CGRect
    ) -> some View {
        Circle()
            .fill(Color.clear)
            .contentShape(Circle())
            .frame(width: handleSize, height: handleSize)
            .position(corner.position(in: frame))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        resizeFrame(
                            corner: corner,
                            location: value.location
                        )
                    }
            )
            .accessibilityLabel("Resize scan area")
    }

    private func resizeFrame(
        corner: FrameCorner,
        location: CGPoint
    ) {
        var frame = actualFrame

        let clampedX = min(
            max(location.x, 12),
            containerSize.width - 12
        )

        let clampedY = min(
            max(location.y, 12),
            containerSize.height - 12
        )

        switch corner {
        case .topLeft:
            let newX = min(clampedX, frame.maxX - minimumWidth)
            let newY = min(clampedY, frame.maxY - minimumHeight)

            frame.size.width = frame.maxX - newX
            frame.size.height = frame.maxY - newY
            frame.origin.x = newX
            frame.origin.y = newY

        case .topRight:
            frame.origin.y = min(
                clampedY,
                frame.maxY - minimumHeight
            )
            frame.size.height = frame.maxY - frame.origin.y
            frame.size.width = max(
                minimumWidth,
                clampedX - frame.minX
            )

        case .bottomLeft:
            frame.origin.x = min(
                clampedX,
                frame.maxX - minimumWidth
            )
            frame.size.width = frame.maxX - frame.origin.x
            frame.size.height = max(
                minimumHeight,
                clampedY - frame.minY
            )

        case .bottomRight:
            frame.size.width = max(
                minimumWidth,
                clampedX - frame.minX
            )
            frame.size.height = max(
                minimumHeight,
                clampedY - frame.minY
            )
        }

        frame.size.width = min(
            frame.width,
            containerSize.width - frame.minX - 12
        )

        frame.size.height = min(
            frame.height,
            containerSize.height - frame.minY - 12
        )

        normalizedFrame = CGRect(
            x: frame.minX / containerSize.width,
            y: frame.minY / containerSize.height,
            width: frame.width / containerSize.width,
            height: frame.height / containerSize.height
        )
    }
}

private enum FrameCorner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    func position(in frame: CGRect) -> CGPoint {
        switch self {
        case .topLeft:
            CGPoint(x: frame.minX, y: frame.minY)

        case .topRight:
            CGPoint(x: frame.maxX, y: frame.minY)

        case .bottomLeft:
            CGPoint(x: frame.minX, y: frame.maxY)

        case .bottomRight:
            CGPoint(x: frame.maxX, y: frame.maxY)
        }
    }
}

// MARK: - Button Styles

private struct ShutterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(
                .spring(response: 0.22, dampingFraction: 0.65),
                value: configuration.isPressed
            )
    }
}

private struct ScannerActionButtonStyle: ButtonStyle {
    let filled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(filled ? Color.black : Color.white)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        filled
                        ? Color.white
                        : Color.white.opacity(0.18)
                    )
            )
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

// MARK: - Preview

#Preview {
    ScanMenuView()
}
