"""#FINAL PROJECT CV

Bibliography: 


*   https://pytorch.org/tutorials/intermediate/torchvision_tutorial.html (using Fast RCNN instead Mask RCNN)
*   https://arxiv.org/abs/1504.08083 (Fast RCNN Paper)
* Data Augmentation: https://github.com/Paperspace/DataAugmentationForObjectDetection
"""

from torchvision.models.detection.faster_rcnn import FastRCNNPredictor
import zipfile
import os
from shutil import copyfile

from data_utils import *
from model_utils import *

warnings.filterwarnings("ignore")

plt.ion()   # interactive mode
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print(device) # not optimal cpu must be chosen GPU

"""Variables"""

partition = 'Train'

fold = 1
batch_size = 1
workers = 0
num_classes  = 2
num_epochs = 1
all_precisions = []

root = os.getcwd()

path = 'data'
files =['/annotations.zip', '/images.zip', '/masks_poly.zip']

for file in files:
  zipPath=root+file
  with zipfile.ZipFile(zipPath, 'r') as zip_ref:
      zip_ref.extractall(root)

mean=np.load(os.path.join(path,'mean-2d.npy'))
std=np.load(os.path.join(path,'std-2d.npy'))

print('Data loaded')

"""### Create Datasets ###"""

my_transforms = Compose([HorizontalFlipTransform(),
                                    ToTensor(),
                                    Normalize(mean,std)])

test_transforms = Compose([ToTensor(), Normalize(mean,std)])

dataset = KidneyDataset(root, transforms = my_transforms)
test_dataset = KidneyDataset(root, transforms = test_transforms)

# split the dataset in train and test set
torch.manual_seed(1)
indices = torch.randperm(len(dataset)).tolist()

train_dataset = torch.utils.data.Subset(dataset, indices[:537])
val_dataset = torch.utils.data.Subset(dataset, indices[537:587])
test_dataset = torch.utils.data.Subset(test_dataset, indices[587:])

train_loader = torch.utils.data.DataLoader(train_dataset, batch_size=batch_size, shuffle=True, num_workers=workers, collate_fn=collate_fn)
test_loader = torch.utils.data.DataLoader(test_dataset, batch_size=batch_size, shuffle=True, num_workers=workers, collate_fn=collate_fn)
val_loader = torch.utils.data.DataLoader(val_dataset, batch_size=batch_size, shuffle=True, num_workers=workers, collate_fn=collate_fn)

print('Dataset and dataloaders created')

"""Finetuning the model"""

model = torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=True, image_mean=mean, image_std=std)
# get number of input features for the classifier
in_features = model.roi_heads.box_predictor.cls_score.in_features
# replace the pre-trained head with a new one
model.roi_heads.box_predictor = FastRCNNPredictor(in_features, num_classes)

# move model to the right device
model.to(device)

# construct an optimizer
params = [p for p in model.parameters() if p.requires_grad]
optimizer = torch.optim.SGD(params, lr=0.005,
                            momentum=0.9, weight_decay=0.0005)
# and a learning rate scheduler
lr_scheduler = torch.optim.lr_scheduler.StepLR(optimizer,
                                               step_size=3,
                                               gamma=0.1)

print('Pretrained model ready')

"""#### Training ####"""

num_epochs = 10
all_acc = []
best_acc=0

for epoch in range(num_epochs):
    # train for one epoch, printing every 10 iterations
    train_one_epoch(model, optimizer, train_loader, device, epoch, print_freq=10)
    # update the learning rate
    lr_scheduler.step()
    # evaluate on the test dataset
    model.eval()
    acc,model,best_acc,_,_,_ = evaluate(model,best_acc, val_loader, device=device, th=0.5, phase='val')
    all_acc.append(acc)

    print('Epoch accuracy: ', acc)

print('Best validation accuracy:',best_acc)

"""#### Testing ####"""

model.eval()
acc, _, _, test_images, test_targets, test_outputs = evaluate(model,best_acc, test_loader, device=device, th=0.5, phase='test')

for i in range(10):
    test_img = test_images[i][0].cpu()
    test_img = test_img.numpy().transpose((1, 2, 0))

    test_tartget = test_targets[i][0]

    prediction = test_outputs[i][0]

    title = 'predicted boxes'

    showBB_predicted(test_img, test_tartget, prediction, title, only_local=True)