import torch
import numpy as np

relu = lambda x: 0.5 * (x + abs(x))

def init_weights(num_components, num_out):
  #initialization
  #pick multipliers so they are close in magnitute to elements in the decomposed Z and H matrices (might need to experiment)
    Z = 0.8 * np.random.rand(num_components, num_components)
    H = 0.8 * np.random.rand(num_components, num_out)

    return Z, H


class DSNMF(torch.nn.Module):
  def __init__(self, data):
    super().__init__()
    self.Zparams = [] #Z matrices
    self.Hparams = [] #H matrices
    self.dane = data

  def forward(self, x):
    wynik = x[0]
    for i in x[1:]:
      wynik = torch.matmul(wynik,i)
    return wynik

  def loss(self, y, y_pred):
    return ((y - y_pred)**2).sum()

  def pretrain(self, layers, epochs):
    #method for pretraining layers, H[n] = Z[n+1] * H[n+1]
    #layers - number of layers in decomposition
    #epochs - vector; number of epochs for each layer
    M = torch.tensor(self.dane)
    x = 0
    for j in range(layers):
      print("LAYER {}".format(j))
      Z, H = init_weights(3, 3) #size of matrices Z=mxm, H=mxn
      pretrain_params = [torch.tensor(Z, requires_grad=True), torch.tensor(H, requires_grad=True)]
      optimizer = torch.optim.Adam(pretrain_params, lr=1e-2, betas=(0.9, 0.999), eps=1e-16)
      
      for i in range(epochs[x]):
        H_pred = self.forward(pretrain_params)
        l = self.loss(M, H_pred)
        optimizer.zero_grad()
        l.backward()
        optimizer.step()
        with torch.no_grad():
          pretrain_params[-1] = relu(pretrain_params[-1]) #force non-negativity on H matrix
        print("Pretrain epoch {}. Residual [{:.6f}]".format(i, l), end="\r")
      x+=1
      print("\n")
      self.Zparams.append(pretrain_params[0].detach().clone())
      self.Hparams.append(pretrain_params[1].detach().clone())
      M = pretrain_params[1].clone()

  def uczenie(self, epochs):
    #final, all layers learning
    print("LEARNING")
    y = torch.tensor(self.dane)
    optimizer = torch.optim.Adam(self.Zparams, lr=1e-2, betas=(0.97, 0.999), eps=1e-16)
    self.Zparams.append(self.Hparams[-1])
    for i in self.Zparams:
      i.requires_grad_()

    for i in range(epochs):
      H_pred = self.forward(self.Zparams)
      l = self.loss(y, H_pred)
      optimizer.zero_grad()
      l.backward()
      optimizer.step()
      with torch.no_grad():
        self.Zparams[-1] = relu(self.Zparams[-1])
      print("Pretrain epoch {}. Residual [{:.6f}]".format(i, l), end="\r")
    print('\n')

  def getsum(self):
    #get final approximation
    wynik = self.Zparams[0]
    for i in self.Zparams[1:]:
      wynik = torch.matmul(wynik, i)
    return wynik.detach().numpy()
