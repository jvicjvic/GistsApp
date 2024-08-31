# Algumas notas sobre a implementação

* O projeto está organizado em módulos por funcionalidade, onde cada módulo possui uma subpasta 'Data' e 'UI', conforme necessário.
* A navegação é gerenciada por coordinators.
* Para persistência dos Favoritos utilizei o `UserDefaults` por questão de praticidade.

## Dependências

* Evitei usar libs externas, a única utilizada foi o SnapKit para  ajustes de layout. Todos os layouts foram feitos em código.
* As dependencias que foram criadas para o projeto estão localizadas na pasta 'Dependencies' na raiz do projeto. Utilizei o SPM para gerenciamento.
* Conforme os requisitos, criei um módulo para rede (`NetworkService`) e um para a tela de favoritos (`FavoriteGists`).
* A funcionalidade de Favoritos trabalha com uma abstração `FavoriteItem`, de modo que seria possível utilizar ela com qualquer objeto que implemente o protocolo. Aqui eu fiz o próprio `Gist` implementar o protocolo. Considerei criar um outro tipo especificamente para os favoritos, mas resolvi fazer o mais simples.

# Screenshots
![Simulator Screen Recording - iPhone 15 Pro - 2024-08-31 at 13 08 50](https://github.com/user-attachments/assets/6021805b-6228-49d3-8a8e-371cb26941b4)
