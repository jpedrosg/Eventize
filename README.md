![Logo FIAP + Eventize](./cover.png)

---


# <img src="https://github.com/jpedrosg/Eventize/assets/57687819/bcb8ece6-3aa0-4dff-9171-39d4411cd793" alt="Eventize Logo" style="height: 25px;"> Eventize - O Seu Guia de Eventos          



O Eventize é um aplicativo revolucionário que torna a descoberta e participação em eventos, shows e baladas mais fácil do que nunca. Com uma ampla gama de recursos e uma interface de usuário intuitiva, o Eventize é o seu companheiro perfeito para uma vida cultural ativa em sua cidade.

## Conteúdo do README

- [Recursos](#recursos)
- [Vídeos de Demonstração](#vídeos-de-demonstração)
- [Roadmap](#roadmap)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Como Usar](#como-usar)
- [Contribuição](#contribuição)
- [Autores](#autores)
- [Licença](#licença)

---

### Recursos

O Eventize oferece uma variedade de recursos projetados para melhorar a sua experiência ao descobrir e participar de eventos em sua cidade:

- **Scenes:**
    - **Event List Screen:** Visualize uma lista completa de eventos e festivais em sua cidade.
    - **Event Map Screen:** Explore eventos em um mapa interativo e descubra o que está acontecendo ao seu redor.
    - **Event Details Screen:** Visualize os detalhes de um evento selecionado.
    - **Tickets Screen:** Acesse facilmente os ingressos para os eventos que você deseja participar.

- **Funcionalidades:**
    - **Authless Experience:** Desfrute de uma experiência sem a necessidade de autenticação inicial.
    - **GPS Location:** Use a localização GPS para encontrar eventos próximos à sua área.
    - **Favorites:** Marque eventos como favoritos para acesso rápido e fácil.
    - **Search:** Pesquise eventos por nome, local ou categoria.
    - **Ticket Validation:** Valide os ingressos diretamente no aplicativo.

- **Extras:**
    - **Acessibilidade:** Tornamos o Eventize acessível a todos.
        - **VoiceOver:** Suporte para VoiceOver para usuários com deficiência visual.
        - **Dynamic Texts:** Textos dinâmicos para facilitar a leitura e a compreensão.
    - **Dark Mode:** A interface do usuário se adapta ao modo escuro para uma experiência noturna mais agradável.
    - **Unit Tests:** Garantimos a qualidade e a confiabilidade com testes unitários.
    - **Snapshot Tests:** Testes de captura de tela para manter a consistência visual.

### Vídeos de Demonstração

Aqui estão [vídeos demonstrativos](https://1drv.ms/f/s!AsGKu1x-W3oTkNIAB7piAEx8JbjNgg?e=B7dQW7) de cada uma das funcionalidades do Eventize:

- [Vídeo da Tela de Lista](https://1drv.ms/v/s!AsGKu1x-W3oTkNIBHxEi_GnpWI9w6w?e=HLhKih)
- [Vídeo da Tela de Mapa](https://1drv.ms/v/s!AsGKu1x-W3oTkNICfxEDNam-fVPDyA?e=Pw10em)
- [Vídeo da Tela de Detalhes](https://1drv.ms/v/s!AsGKu1x-W3oTkNID9HdnBIi8KEK9Zg?e=RpzPmR)
- [Vídeo da Tela de Tickets](https://1drv.ms/v/s!AsGKu1x-W3oTkNIEPBDaEEa9ejeM0w?e=tyFlZw)
- [Vídeo do Experiência Sem Login](https://1drv.ms/v/s!AsGKu1x-W3oTkNIFDVKilCslz50TgQ?e=cjt3fe)
- [Vídeo do GPS](https://1drv.ms/v/s!AsGKu1x-W3oTkNIFDVKilCslz50TgQ?e=cjt3fe)
- [Vídeo do Favoritos](https://1drv.ms/v/s!AsGKu1x-W3oTkNIGsSdt3NCBPBkZJg?e=mv3rGv)
- [Vídeo da Pesquisa](https://1drv.ms/v/s!AsGKu1x-W3oTkNIHLjP2B4Q669yabQ?e=BcRmHA)
- [Vídeo da Acessibilidade (VoiceOver)](https://1drv.ms/v/s!AsGKu1x-W3oTkNIIcH2BmTao3hma4w?e=4rSDl5)
- [Vídeo da Acessibilidade (Dynamic Texts)](https://1drv.ms/v/s!AsGKu1x-W3oTkNIJEl8mMOpE5brdOQ?e=vxeh0G)
- [Vídeo do Dark Mode](https://1drv.ms/v/s!AsGKu1x-W3oTkNIKfukrD0s33PiI6w?e=JQsuMa)

### Roadmap

Este é o **MVP (Minimum Viable Product) do Eventize**, uma versão inicial do aplicativo com funcionalidades essenciais para oferecer uma experiência básica aos usuários. Estamos comprometidos em continuar melhorando e expandindo o aplicativo. Alguns dos recursos planejados para a versão 1.0 incluem:

- **Login / Register:** Permitirá aos usuários criar contas personalizadas e acessar recursos exclusivos.
- **Location Selector:** Aprimoramento da funcionalidade de localização que possibilitará usuarios selectionarem uma nova localização (hoje isso é possível apenas pelo mapa, quando feito um long-press em uma nova região).
- **Profile / Preferences Screen:** Os usuários poderão personalizar suas preferências e perfis.
- **Ticket QR Code Generation:** Geração de códigos QR para ingressos para eventos.
- **Localization:** Suporte a múltiplos idiomas para atender a uma audiência global.
- **Error States:** Lidar com erros de forma mais robusta para uma experiência de usuário mais confiável.
- **Loading States:** Melhorias na interface do usuário para indicar o carregamento de conteúdo.
- **CI / CD:** Implementação de integração contínua e entrega contínua para um ciclo de desenvolvimento mais eficiente.

Agradecemos por usar o Eventize e estamos ansiosos para trazer essas melhorias e recursos emocionantes na versão 1.0!


### Pré-requisitos

Antes de começar, certifique-se de ter os seguintes requisitos em seu ambiente de desenvolvimento:

- iOS SDK 14.0+
- Xcode 12.0+
- Swift 5.0+

### Instalação

1. Clone este repositório:

```bash
git clone https://github.com/jpedrosg/Eventize/tree/main
```

2. Abra o projeto no Xcode:

```bash
cd eventize
open Eventize.xcodeproj
```

3. Execute o aplicativo no simulador ou em um dispositivo iOS.

### Como Rodar Testes
1. Abra o projeto no Xcode.

2. Altere o seu simulador para um iPhone 14, iOS 16+.

3. Na barra superior: Product > Test (ou aperte CMD+U)

4. Testes Especiais:
   - **LocationManagerTests:** Utilize um telefone real como RUN DESTINATION.
   - **DoubleCurrencyFormattingTests:** Certifique-se de que seu simulador ou celular tem região definida como Brasil.
   - **Snapshot Tests:** Certifique-se de utilizar o iPhone 14, com iOS 16+ como simulador.

### Como Usar

Siga nossos [vídeos demonstrativos](#vídeos-de-demonstração) para aprender a usar o Eventize e aproveitar ao máximo todas as suas funcionalidades.

### Contribuição

Se você deseja contribuir para o desenvolvimento do Eventize, siga estas etapas:

1. Faça um fork do repositório.
2. Crie sua própria branch para a implementação de novos recursos ou correções de bugs: `git checkout -b minha-nova-funcionalidade`
3. Faça commits das suas mudanças: `git commit -m 'Adicione uma nova funcionalidade'`
4. Envie as mudanças para o seu fork: `git push origin minha-nova-funcionalidade`
5. Abra uma pull request para revisão.

### Autores

- João Pedro Giarrante
- João Victor Fernandes
- Giulia Penteado

### Licença

Este projeto está licenciado sob a [MIT License](https://choosealicense.com/licenses/mit/) - Veja o arquivo [LICENSE.md](LICENSE.md) para mais detalhes.

---

Aproveite o desenvolvimento do seu aplicativo Eventize e continue adicionando recursos e melhorias. Lembre-se de personalizar este README com links e informações específicas do seu projeto. Boa sorte!
