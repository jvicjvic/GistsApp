# Notas sobre a implementação

* O projeto está organizado em módulos por funcionalidade, onde cada módulo possui uma subpasta 'Data' e 'UI', conforme necessário.
* A navegação é gerenciada por coordinators.
* Para persistência dos Favoritos utilizei o `UserDefaults` por questão de praticidade.
* O acesso aos dados é feito através de objetos *Repository*, e para cada repository há um protocolo definido (ex.: `GistRepository` e `ProductionGistRepository`). Isso permite que seja simples de mockar ou substituir a camada de acesso a dados.
* A funcionalidade de Favoritos trabalha com uma abstração `FavoriteItem`, de modo que seria possível utilizar ela com qualquer objeto que implemente o protocolo. Aqui eu fiz o objeto `Gist` implementar o protocolo. Considerei criar um outro tipo especificamente para os favoritos, mas resolvi fazer o mais simples.


## Dependências

* Evitei usar libs externas, a única exceção sendo SnapKit para ajustes de layout. Todos os layouts foram feitos em código.
* As dependencias criadas para o projeto estão localizadas na pasta 'Dependencies', na raiz do projeto. Utilizei SPM para gerenciamento.
* Conforme os requisitos, criei um módulo para rede (`NetworkService`) e um para a tela de favoritos (`FavoriteGists`).
* Utilizei Combine apenas para gerenciamento de eventos. Cogitei fazer de outras maneiras, mas assim me pareceu mais prático.

# Screenshots
![Simulator Screen Recording - iPhone 15 Pro - 2024-08-31 at 13 08 50](https://github.com/user-attachments/assets/6021805b-6228-49d3-8a8e-371cb26941b4)
