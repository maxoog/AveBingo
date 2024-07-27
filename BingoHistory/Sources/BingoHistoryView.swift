//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import SwiftUI
import ScreenFactoryContracts
import Resources

public struct BingoHistoryView: View {
    let screenFactory: ScreenFactoryProtocol
    @ObservedObject var viewModel: BingoHistoryViewModel
    
    public init(
        screenFactory: ScreenFactoryProtocol,
        viewModel: BingoHistoryViewModel
    ) {
        self.screenFactory = screenFactory
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text("MY\nBINGOS")
                        .font(AppFont.headline1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {}, label: {
                        HStack(spacing: 10) {
                            Image("add_icon", bundle: .assets)
                            
                            Text("Add new")
                                .font(AppFont.body)
                                .foregroundStyle(Color.white)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background {
                            Color.blue
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    })
                }
                .padding(.horizontal, 14)

                Spacer()
                
                Image("empty_state_illustration", bundle: .assets)
                    .resizable()
                    .scaledToFill()
                    .padding(.leading, 40)
                    .padding(.trailing, 20)
                    .padding(.top, 144)
                
                Text("NOTHING HERE")
                    .font(AppFont.headline2)
                    .padding(.top, -12)
                
                Spacer()
            }
        }
    }
}
