//
//  ChatList.swift
//  HealthChat
//
//  Created by Eric Hovhannisyan on 10.12.24.
//

import SwiftUI
internal import ExyteChat

@Observable
final class ConversationsViewModel: ViewModel {
    let user: HealthChatUser
    var navigationPath: [ConversationDestination] = []
    
    let onConversationSelected: ConversationSelection
    
    init(
        user: HealthChatUser,
        onConversationSelected: @escaping ConversationSelection
    ) {
        self.user = user
        self.onConversationSelected = onConversationSelected
    }
    
    func handleConversationTap(_ conversation: HealthChatConversation) {
        onConversationSelected(conversation)
        navigationPath.append(.chat)
    }
}

enum ConversationDestination: Hashable {
    case chat
}

struct ConversationsScreen: View {
    @Environment(HealthChatModel.self) private var model
    @Bindable private(set) var viewModel: ConversationsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            List(model.conversations) { conversation in
                ConversationCell(
                    title: conversation.title,
                    subtitle: "Here should be the last message description",
                    imageURL: URL(string: defaultImage)!
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .onTapGesture {
                    viewModel.handleConversationTap(conversation)
                }
            }
            .navigationDestination(for: ConversationDestination.self) { destination in
                switch destination {
                case .chat:
                    ChatScreen()
                }
            }
        }
    }
}

private struct ConversationCell: View {
    let title: String
    let subtitle: String
    let imageURL: URL
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: imageURL)
                .scaledToFill()
                .clipped()
                .frame(width: 80, height: 80)
                .clipShape(.capsule)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    let sender = HealthChatUser(
        id: senderUser.id,
        name: senderUser.name,
        avatarURL: senderUser.avatarURL,
        isCurrentUser: true
    )
    
    let vm = ConversationsViewModel(user: sender, onConversationSelected: { _ in })
    ConversationsScreen(viewModel: vm)
}


let defaultImage = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIALcAwQMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAEBQMGAAIHAQj/xABAEAACAQMDAAcECAQFAwUAAAABAgMABBEFEiEGEyIxQVFhFDJxgSNCUpGhscHwBxUz4VNicoLRJEPxFheSorL/xAAaAQACAwEBAAAAAAAAAAAAAAACAwABBAUG/8QAKhEAAgMAAgIBAgYCAwAAAAAAAAECAxESIQQxQSJREyMyYXGBM1IFFEL/2gAMAwEAAhEDEQA/AEuvYZYyv2aqEo7bfGn08jPD2vKkdx75rLFYjXJ6wOQc1GzbeK3m96oHOaNMBo8Zq0LVm2vMUzReM93UZbt2aD21NG+2qYUV2TXEuFzQT3LUSzbgSais7QXFwFfOzBJxVRaJLQc3TZq09DrpC7CTvNAS6VDOB2tpU/Iist7drdt0Q7vCr6AcWde0RYpiRjOAOKU9ONGiZGliXawGaqdj0qvdOLCBRnOTupvJ0u/mcPU3oA3L2ZBkY+NQBxelVsmJl2v9XIq8dCtdhs7hbK57O9uwfP0qkRdTFcqRKXVhwEU5Na37FwrQthlYFTnlT8KJMua2J36ynezn9ptQWjbmSPz9RVli1WzlRX9pjXI7mYA1yzoL0mF5Ette4FyqgEH648xTHploa39m01unaHNM6ZmWp4jpC31q3u3EJ/3ipkkSTlGDfA1809WoHVsu0jII9a69/CGNY+jTuPeediT+H6VXTGvV7L0RWhSpKyqLaIClaFaKrUrmrKwGxWURsrKvSsPmFJVljytKrgfStR9nHstzS+5P0rVlNoBcd9Q4qWfvrUDsn4VaIRmsrRzUbPwaNRF8jdnxzRdtZ3E0HXomI/MsADQ1natdNy/A+dWW16qPT1jVhs2gZbxwap9FrWJzZT9YsbRsjN3A/nTBbJLSDrFkV33YY+OfLH776IWVIV42uTwnpx3/AJD5UueZW5mztyT6k/sVQf8AJJLczwu8fDug53eAPNDz3MjIm7jC9w4oW4uZLiWSQNklcHPj4f8AFDtPIu6P/b8KtIBsJDOyg5wd3ZPkKlXUEj7OGLjxPOaESdgwGdmB71aO3XvI7SKpA7se9V4Voc87MoKFQqgZIOCKm9tkAjnkUMVGGLeNLYw/VBt6kkEY8hWyS9V2ANwHPzqYRlvkuU9lhvbEGOeNlII8c+FdG6K9I47tBb3rdXMVGFk43E/Z/fhXGo9QmWMxwBUPjj9KLs9VaO6SWcuwKFB55olLsU69Lf01hFlrT7V2LMNy+tXn+E+sQHTHsXZVkjcnae85qha/NLqemaZdTr9L1eDj4fs0DAZICj2z7ZO4FfOrra5YVZB/hLPg+j1lVxla230j6KLdDR7f2xt0mzLfGnBpjjjwVCXJaSq/Nb0NmiAeyKFjEe1lZWVRZ8t2/wDQNKbr+s1M7Zv+nNLbv+oaQzUATeNbKPoj8K0mNbrIojx51EU2CSioxxyfCimKVoOrJwKZuC8C9LBE2E5y3cOMU8eJRbSda30YONvHPiajtre1tIW3ACRwACfDjmhJrhIY3IKsxYYwc5P9v1pTesaliMvGhSfh2ZfPz/8ANK7koVLb8sTwPAVlxd7m3LyzeFaRWkl1tOduaJYvYL2XSIGKDaQ2SO8VmUyGTeT9UeXxqzaR0bgl5mOfTzqy23RKwYjCspxQO+CY2PjTaOdq5kQ9bH9Iw5c99QRBSwADbxn5iusnoVavH9ESG8z3Uk1L+Ht5u327R48txqLyIsqXjTRRlKR7TtXJ94HvFeRvHHkty+cAUbqOj3Gnu0d9E4YHsnwpeFiTbtdifEeVNTT9CXFr2S3JPWloxs549P3ii7C6bcsmfpEIO494oWcqNgCY8cnxrbrwm14V2HOMr3E1ZRdZtchntLW0MMkcMSBI2ZMZPqaCldhIQpwMZBpMb6Sa06jblz4+VWEWjpZwS7lZDGAcHlW/Yqt7TLSWNHfehW6Toxp0sjbpJIEZviRTwpVY/hvN13RDTxuzsUp9xIq005+zNCK4o06tRWwFe1h7uKoIysrKyoQ+U7RvojQF3/UNFw9mM/GgLl/pDSGaUBXHGaCZ2o2Y0HKKuIMjXe3wonTUke5Ux8hWBY+lB030GHrpCfs8UT9AxWseTXCiUibhCOSq8kYGPlnP3Umv3ilfbDwngcd4ppeKsVuXTeQ42uPLBpYYoZIUaFTvY89wApaXY1v4BLWPrZvnirDbW+1BTXoB0bOpSPO6/Rqcc91H6ppwtrx4l7h3UFjHUJaaaUNoFWq1TcFPpVc022bePjVp0+JlXFYpLs6K6QxtE4orZQybl4oiMtj3agtsU6zo9tqMBiuYlOe4iqZL0EgAUb2Xt5DDk/CugztzQd0cLnyqKcovonFS9nHelelR2GqNHFlY2UFd3h6UnDJGrBzkZG1T41benD41IcZwnd86qN0uXJddu3CgV0KnsUzmXJRm0gy1uwcBIs4q2WydfYyTIcLnAXPkBVKTLR5iUoyeXGat3RmVo9OaC4+s7AcefH/NMj7FTb4ncf4YCL/0ladV5vv/ANW7mrdVZ/h3bR23RKwSNcZUlvU5OasxpsvYiH6Tw0PJcxxsA7Y9KmkYKvPdVP6SX0ctxDahsuz5x5ChbxF42y1e1R/aryqp1Ne0HMPgzgshXBpVce+a3WZiMV4y7hmpLMGx0CkPNDyUZIvNCzChRGDNTTRL3qt0beLZBzSp6MsOXRQO4hmP6CifoWm0xndiSNHdg218HGcrwKGghuGsZLuBcQwuqszvjtMeMevHJo6aKW9At7BonUKW2+6R4kHPqcetDW3tjpHp0C7t77goPCt3cj4D86pDJI6L0M6VHStLXTrPR3vLwJ1s0ntMYiQeZYbsDj0pDqHSrULqeV4rKBmdiW2Fn/Hj76Jk04aB0fuoCVjvJLyWFwOAEGP0xSq1vLqMYsLKSVR3sBjNBIdBP4GGn9Ib5RvnhhRQyqRk7snPgefA1etF1mGfCzlY37mRuCD865/fpdSWfXXdgYjsySU9cYyMeh8aR3UwvpbOC4HZHYBHBK5GBnxxk49PgKW4RfY1TnuHehc2pYN10QUDJJYUj1Lp7oNkXiiMt0ycZt1yM/6jx+NUzVOithYWGnXFlLcBLi4SCaMyEqQ3GcV7rE9jYN1clijKo9wLyFA78UC47gxqWaOf/cHS7uTaLS4iOcdtkGf/ALU1juDe28bQxNsk9xsjB+BBIqlw6l0fuoVEtgqdZkKWUc4OOD99E6bNLphMmmt1lnKe1Hnjng/CpKuD9gq2xd9AnT3T3jCXbRsoAKklcg+QqhrMu1PLP3mrj0j6QXF1YoL2SSWITFWiPc4UkD8qp+oRRrdNHA2Ys7kPmp5FPrSSxGa5ty1hYizKuzJBOdq+VWGy3RPHI78AcL4Ul0q3laPcH9c58KbGURIkbDdggfdTV70RP1h9C/w8ff0Ssm8w3/6NWJzhSeBgeNUX+FutW1zoKWJdRcW5IKE8kE5B/H8KteqTKLYoG5amT6YmHawrHSXXHuJDBZsVjThnH1jVb0pVbUld23NnxOai6QSLbyyLu780r0CXbcg7u40h18npsjPIYdN7NZSzr6yr4iuR83QSd1E9pxWkcWFFFQrxU9htNIDePmhbhaazKvVfOk9wfpDU4gKRAa9ikaF90ZIPgR4Vtt4NaKO0M0SAfRa9FVL420dsWXUJp4o3OO4Enn8B31bOhemW2odI5bi26v2WKfCjvbbuJU+mQPzqi9F2eO7nEYKyCznKsO8t1Z/Qmul/wzRdNtFtp4THePciSVW4baF7I+45+Zpb6Zrhkqw3pPZNJrF2kb7DIwkA2jL8BWAPgBs588nyOB7bo5AsYlSSWKX/ACEYP4U16Y31uNDVSqtPdSbxwCcKcA+ndVcsBqaQ9b/OpIIsZwyK+PmwNIs00UeuzfWba6trRuuvJOqAPfju+VUSzia41dZyOA2I8+PrTfpBqDNKkNxezXLMcbpMKMfBcCt9Cjt5tWAibgEYHrUWpBSyUlhfmsDd6KbfjeQrRk9yuDuU/eBWlxYDULaO6h2hiO0siAkEcEHHiDkGn/UKltHh1xgc+tI9Vtr21eS90ycI5GZI3XcrjzwPH4eVJSY543uC2WzzCYbjTrKZe7JSg00+CwhldUMShc9Svie4AevlT7TpdZvYyYk0p9w97c/H+3+9Sx6PKrifUp1uJo/dWNCsaHzx359STVvc7KfHsoXSrT0h0CNZkUyBhuYL3k53H780oPRtbbR0nuImeXq2kLjgIFGQPXIBq89IbaO6ntLNl3LJcplR4gHOPwrfpnJb2ulSqQB1iiGFG9cg/coI+6ihN4khU6462c7sZRzhdq4GMUNfS/TL8aiExW47ShfDih7uTc+a3JnNku9Osfw002zubKTUJu3OshVVDEbBgeA885qxX2vizDxLLnDFeTnNcUsby6jx7I8ySOP+2xGfurefU7gHbKX3eIbvJ+dYbfHtlbv4nX2NNVtcYdw/sums6p7TMW3Z9Kl0yx1C0vIHu7aaKORhtZlOP7VXOj951OoW11KN4jkVyvwOa6Xq3SnT7i0hSJ2ZjIGYsuNuKjutrsjCK1Mt1xlFy0aZrylP89s/8avK6HCf2MWR+5xbeoUVss9AsGJxW6dml4N5aTvN9G1LZH3SZoiZ++g276JIBsleRdlQ55FZipobZ5fcokDvIfdDdTh0nXLW6uYw8AJWRf8AKRg/hV80zUxcdJry6UxtvGSYwQGHOK5tY2UwkAK5ye+rzYwLaWkT7MS7HVj6Y4/WgnXq0ZXZj4kWuX5vdYhiL5RbdFjHl3Z/E0Lq2tJbyG1Yf0uzj1/eaRvctBqVtMe6NvD45p70o0SIu93AwPtLdame47uf38KzyXaNdcnxeFS1S7W5k3bcVrok9zDfRPCzd/FFaZp15fajHYsEjeRtv0i93lV90DodrsIEkUdopeISgt3/AOnuPNMbxYBGLctbwAXpS/VG0vZp1YDB6l9v40/0bpVYiAQ4m2p3vK+/d8zTX/0vqd5BG9zbaaGlXjMYZhjnypJrvR7VNE0+S6t47KWONC7q0PcMc4P3UprTSv2YK/SK20vWY7mzfbZzviWMdyt9oD18R51cbi63whkbO/urlV/o17d6c997E1tkjs7uHz5Crkbw2ljZWkpxMsY3AeGB/wCaVYl8BQb75Gl3OsvSrSED4O4sD5HBpP8AxInea/tI1dfoUICn3s8Hd8+KGl1WS31+C7C9a8SMwHxpPrWpz6lcNJMO0T3eQp9NWtNma67E0hRIsks6RorNK7BQqjJJPkKO1DQr2w6v2+3lgdxlQ47x+tDaLqqabrllfSoXjglDMF78cg/nVq/iB0vsdcitrfTGd9hLNIUKgcYxzVWWWxvjGMdj9/sLrjCVbcnjBejtskD+0OuFxgNjxovpBBb3sO+NVDqO+p9AeTVtM6iKLbsQLJu4FA38qwNJZSxkzodu1Rkk1VFsZ2SU45JGzzfFdVMHVLYs80vo7qMlus0Kjq8gb24Bpp0v6Pz6dpKzRXhlVSA4K7T34455GauPRPU4obKOCFcBE7UBI3IfP1qg9LtU9r1Ce1S432vWEoE7hj9M5rD4/kXX+RieJfsMu8SFVMuS7SK/1z/arKi7H+K1e16DnL7HB4oA245qNmpmY1MIHpQj2+aRg3QB35oyxtopUDSLuLA/KvGtOamtkeLIWgnFtdGjxbK4WJ2LUDTwCO4ZB7qtwaa6e8UEZZvKhDE2Szd9DyTYO3yptex9iLHGUm4rEMJtXaFyYosg+NH6f0ia6xBcHb9JiMjw4Pf+FVwndzUNq5huEcKW590eNXOXICMcejW8GJGGd2GI+6rDpd+dQ0b2OQnrIR9GfGkd5A6dWxR0MihkSTg4PxHpW2nE21wskZ93G8eVZ5x6NVc+L1h9vcHrlEindGeCDhl+Bq5aGbwqvsevX8AKhdjyhxgd2NwNI5NMjvHjuYeOsHPo1TyW2pafGGgJYDns0nkbYrPaLukWsSwALr10FUEfUyfPGBU8EN9cRiPULuaeL7MgUEn5YpP0X/m9wwed0WIj51Yru5itoy0rYCjk+dBOQX0/CFPSKWC2MQb3ce76Duqg3980lxNPlV3HbxUvSnW/adRY7uypO3FVt5HubgRx9pmyceQ7yauEPkTO34JSXmmLozDHGfOpblY+p97nHPxpRJqaogEO7HquBUBvZJRW2KxHPm9ZFcIVYsvcTUMZYPkrwKnQs74PcaZwQLtHZotBwsHQGSOS+mM10YJOr2qobAPOaU6xdPZdLDdbzddWwL8g+GCPuqIwR54Xmt1h492sq8f86Vkn0zovzX+FGqKzCPXdTOo4EEEkaA5O7v5pSzTjAbccLtHoKscNurqezWNZ8+7Tq6lXHikI8nybL58rCt7JPtxfcKyrN7Gv+Ev/AMTWVOMvuL5V/YH6ms6iisrWwNNM+gRhrwRUYxWtMK9WTQWVF6hqRSRSSzlYwWPhtqz/AMuuLx1hto+skkOAtE6robaU8OkWSm61WRd1yyc7M/VHljxPeaXZYo9DqapWP9hVoOiDUL1YHkBVVLyuo7MaDvJPj5AeZrfVdVht3a30iJLW3XgOigSSeZZu/NWa+09einReS0YhtQvsdey/VXwQfrXN7xmMhX7NZoN2S79GycY1R69nRdVthcdEtFusnr/ZxuY8kjJqr252Nlm97Ofj4flVne8in6FaYitzFBtPxBNUg3TRTkPnaMnj1pkfbQia1Jj2z1SS1BT/ALZOas1hrIMSLI3OcN481QrpHA61NzIwDA+GKij1CSKhlUn6CjfKKw6v/PUgTrIWwR3gePw/fhSTpF0kaWPqd2c5NUY6pK9TW0V3qMoWBGYtwTQqpLthu6UliIXkknl2ICWZhgDvJq66N0f/AJNpU2oXoAuWUkL9gY8Kb9EOi8WnAXNwu6dhnLeHwonpsxXQrzZ9g0my3k+ERtNPH6pFLv8AQbTVUNxaMIZ8ZKhey/y8DVYbT54ZGRgrKpwSpyKf6BqDEp4huCPI91GdJYGt5U1K3AKyALKvgT50Vds4T4sZb41dsOcRDY6cxbdt76cJZ7VAorT5YLi3EqH0x5UbHGr1ug1JdHJsjKuWMXJZ1J7Lto9k2VE0ijmjwDTyzt15qSaFQa0huFLVLPKu2q9Bt6iLYtZWm+sqaLwGNrXvUKoo8rnitlh57s+lRtL2Eot+hU9tu5o3TNFkvbyO3t1DO/gTgAeJptFo8+xpJSIEXlml4xWaTrFppOu2bqMwNJ1Usrce9kA48BnHn8qTK+K/T7Hw8acu36LdouhW2hozttknji3yyEYC+QA9efuqldHNSRbnU76TtXMs5AbyXOf+a6JryvHoepPGQZGjcqfE4WuE2Ny0LkeBFYZ7P2dGlKCwc9KbqS8uVZm7PNUi+TE7Vbj/ANQw9RVf1WDts/kx/f507x+ngrylsdPLK9lS0MGcp5eVQtFvYtWsC91M7eDetMb7E/Bq1x1mnxwfY/f6mt7LSfasGtRb7ZMetNtMd7S5jlIymRkelU5Yi1FNjPSuicIAklQc+dXHStMgtSojjUcccVllJHcIHRdvApjbLhs1klNv2a4xjFdBJG1MUj1xOsjVDzuOKdscA0m1I5lQgZww4pftjEc0ubYWGvTW6HCMVkUepq1iJbqyMcoyCMEedIekiY6ToAckQgE+eMCrDaf0R8BTPK+mSaC8HJVtMrMdo+jaisTktZ3R2qfI+ANP7eRY8CTv8G/5rTV7X2vSZ0+sF3r8RUOnSe26fDP4uuHB8SODUje4/Wi5+NGxcJf0GTTRE4oZ3goeWPYx3e750uvb6OAYrpV3RsWo4tvjSplkhiGhD58q1ubiPbx30BYzrdmjTb00SQ+0VlS+y/5a9qiFr03Q5p0jll7EbeH1m9ee4fGnFvaW1sTsATbyWblvifLw/D4VPqGqpBC0oXOGZYkz7zDAHyz+VIbyZ41W0Vt0zdq5fxLH6vy8fWuVdbKX8HYooUQXV7w3j7EJW2iJ2g/WP2jVX1SMzwsDwDnGadTEPIY1/px95+0aX3qNJhF5d+yq0qD7Nc4fT0OdE6cRS6TDBfgtNGhieQ9zAD8zxVK1myW2un6nmE4aM+ankfv0oK4kFhqMsajrIH7we4+tO+v/AJvoCSqcy2n0J89neufvNaZRa7Rki1J8SPRPpFK1pf2g7ZZew/4it+j7DdtPvc5p7HbLNEwzja3efj++P70VL/MB8qLVS/koj2z28mx+8cg/aHnTPT/D400vtOCAq6los5BXvj9R6elBJZzW7B8B4ieJE5Hz8vnj502cX7M1U0+mTT2/c/rTPTRFgbl5rIoPabf4CtYY5bd8L3UhyZozHpb9OlAiCqvdTCOWq3YzSYGe6msT5GKQ0/gcs+Rg01CzKoO9u5OR6mtDcL7q9tvwFQ37MtrI3p99aKaHvKRluvWOMShahJ7X0kdvIfr/AGqyQjbEo9KrOir1+o3Nz5vj9/jVoUdgVn8uSczoeBHKkbgAowPcRSPotkQXlufqXDY+B5p4/wDT5pJ0bXJ1NycA3HB+X9xSI/45Gh/5EM7mHeARjPcfX999LtR0GG9j+jOxgOCKaW1z1tz1Mibd0YdD9rk5/SiHi+/9KqNkoPpl2QhYskinaVplxY3bLMMp4MvIp6F4o6eAMuZVyPtAcigpY3XOxtyeec10avNT6mci7/jWu63/AEeVlQ9qva1fjVGL/rXf6jS4vmhtop87pFhMi8YAZ2JBx6Arj+1eBikBfvY8D4msrK49no7kF0RCMAY8uTS7f10k8p7l+jX0+0fyHzNe1lFEKRWNSAkMz45zsHwHJ/MfdQWjX72F6oHajc7HXzBrKyuhWtjjOba+Mk0XLTLbT5ZRdKrdpiM5IwfHimG5orpgPsZ4+X/I+6srKx1v83Ddd3Q2FQNDegJjbJ4YHBoZ9JaKUmJjGw+yaysrptnEZ7DHcxE9mI/7QM/dXr7yfpIVB9GrKyg4Rfsv8SS9EkSuMbY0H+omj4Y3OOuO4eCjgVlZV8Ir0R2SfsPhjwO0FUD50m6X6l7PYSJEMHHBrKyi0F/BXOj6GKIhvezTxG4rysrjXfqZ6Oj9CNNSn6qylk8lNeaRZFbSC0B5ky0r+ZPJ/wCKysoG8gM/9E+sR9THFcQ99tIOP8p4I/I/Kj02vGG+dZWUt9xKI3G2JmIzjnFQSQqzEZxuFZWVEWn2RdUPsrXlZWVfJln/2Q=="

let senderUser = User(
    id: "preview_sender_id",
    name: "preview_sender",
    avatarURL: nil,
    isCurrentUser: true
)

let receiverUser = User(
    id: "preview_receiver_id",
    name: "preview_receiver",
    avatarURL: nil,
    isCurrentUser: false
)
