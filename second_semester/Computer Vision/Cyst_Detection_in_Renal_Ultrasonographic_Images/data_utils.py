import os
import random
import torchvision.transforms.functional as FT
import torchvision
from skimage import io, transform
import matplotlib.patches as patches
import numpy as np
import matplotlib.pyplot as plt
import torch
import scipy.io as sio
from torch.utils.data import Dataset
import warnings
warnings.filterwarnings("ignore")


class KidneyDataset(Dataset):

    def __init__(self, root, partition, fold, only_local=True, transforms=None):
        self.root = root
        self.transforms = transforms
        self.only_local = only_local
        # load all image files, sorting them to
        # ensure that they are aligned

        self.imgs_files, self.mask_files, self.annotations_files = self.get_imgs_masks_labels_annotations(partition)

        self.class_names = ("Quiste")
        self.class_dict = {class_name: i + 1 for i, class_name in enumerate(self.class_names)}
        self.class_dict["Background"] = 0

    def __getitem__(self, idx):

        if torch.is_tensor(idx):
            idx = idx.tolist()
        # load images ad masks
        img_path = self.imgs_files[idx]
        image = io.imread(img_path)
        # we want the kidney mask in order to crop te kidney to transform
        mask_path = self.mask_files[idx]
        mask = sio.loadmat(mask_path)['mask']

        boxes, labels = self._get_annotation(idx)

        num_objs = boxes.shape[0]
        # convert everything into a torch.Tensor
        boxes = torch.as_tensor(boxes, dtype=torch.float32)

        # there is only one class
        labels = torch.as_tensor(labels, dtype=torch.int64)
        if (len(boxes) == 0):
            area = torch.as_tensor(0, dtype=torch.float32)
            labels = torch.as_tensor([0], dtype=torch.int64)
        else:
            area = (boxes[:, 0] + boxes[:, 2]) * (boxes[:, 1] + boxes[:, 3])

        # suppose all instances are not crowd
        iscrowd = torch.zeros((num_objs,), dtype=torch.int64)

        target = {}
        target["boxes"] = boxes
        target["labels"] = labels
        #        target["masks"] = masks
        #        target["image_id"] = image_id
        target["area"] = area
        target["iscrowd"] = iscrowd

        #        sample = {'image':image, 'mask':mask, 'boxes':boxes, 'labels':labels}

        if self.transforms is not None:
            image, target = self.transforms(image, target)

        return image, target

    def __len__(self):
        return len(self.imgs_files)

    def get_imgs_masks_labels_annotations(self, partition):

        imgs_files = [os.path.join(self.root, 'images_quistes', f) for f in
                      sorted(os.listdir(os.path.join(self.root, 'images_quistes')))
                      if (os.path.isfile(os.path.join(self.root, 'images_quistes', f)) and f.endswith('.jpg'))]

        tr = round(len(imgs_files) * 0.6)  # train indexes
        # print(tr)
        v = round(tr + round(len(imgs_files) * 0.2))  # validation indexes
        # print(v)

        masks_files = [os.path.join(self.root, 'masks_poly_quistes', f) for f in
                       sorted(os.listdir(os.path.join(self.root, 'masks_poly_quistes')))
                       if (os.path.isfile(os.path.join(self.root, 'masks_poly_quistes', f)) and f.endswith('.mat'))]

        annotations_files = [os.path.join(self.root, 'annotations_quistes', f) for f in
                             sorted(os.listdir(os.path.join(self.root, 'annotations_quistes')))
                             if
                             (os.path.isfile(os.path.join(self.root, 'annotations_quistes', f)) and f.endswith('.txt'))]
        # print('Annotation files: ', len(annotations_files))

        # Depending on the partition, a set of indexes within the dataset will be selected
        if (partition == 'Train'):
            imgs_files, masks_files, annotations_files = imgs_files[:tr], masks_files[:tr], annotations_files[:tr]
        if (partition == 'Val'):
            imgs_files, masks_files, annotations_files = imgs_files[tr:v], masks_files[tr:v], annotations_files[tr:v]
        elif (partition == 'Test'):
            imgs_files, masks_files, annotations_files = imgs_files[v:], masks_files[v:], annotations_files[v:]

        print('Image files in %s = %d' % (partition, len(imgs_files)))
        print('Mask files in %s = %d' % (partition, len(masks_files)))
        print('Annotation files in %s = %d' % (partition, len(annotations_files)))

        return imgs_files, masks_files, annotations_files

    def _get_annotation(self, idx):
        # print(idx)
        annotation_file = self.annotations_files[idx]

        objects, string_boxes = self.find_boxes_and_objects(annotation_file)

        labels = []
        boxes = []

        for obj, bbox in zip(objects, string_boxes):
            if obj in self.class_names:
                # VOC dataset format follows Matlab, in which indexes start from 0
                xmin = float(bbox[0])
                ymin = float(bbox[1])
                w = float(bbox[2])
                h = float(bbox[3])
                boxes.append([xmin, ymin, xmin + w, ymin + h])
                labels.append(self.class_dict[obj])

        return (np.array(boxes, dtype=np.float32),
                np.array(labels, dtype=np.int64))

    def find_boxes_and_objects(self, annotation_file):  # only check for Quistes
        objects = []
        boxes = []

        with open(annotation_file, encoding="ISO-8859-1") as f:
            lines = f.readlines()

        if (len(lines) > 6):
            Bounding_boxes = lines[6:]
            for b in Bounding_boxes:
                l = b.rstrip()
                pat = int(l[-1])

                box_aux = l[l.index(':') + 1:-1]

                if (pat == 2 or pat == 3):
                    objects.append(self.class_names[0])  # Quistes
                # elif (pat==4):
                #     objects.append(self.class_names[1])#Piramides
                # elif(pat==7):
                #     objects.append(self.class_names[2])#Hidronefrosis
                # else:
                #     objects.append(self.class_names[3])#Otros

                box = box_aux.split()
                boxes.append(box)

        return objects, boxes


def collate_fn(batch):
    return tuple(zip(*batch))


def showBB(image, target, title, only_local=True):
    boxes = target['boxes']
    labels = target['labels']

    label_map = {"Backgorund": 0, "Quiste": 1}
    distinct_colors = ['#FFFFFF', '#e6194b']
    label_color_map = {k: distinct_colors[i] for i, k in enumerate(label_map.keys())}

    # Display the image
    fig = plt.figure(figsize=(10, 5))
    ax = fig.add_subplot(111)
    plt.imshow(image)

    for box, label in zip(boxes, labels):

        if (type(box).__module__ == np.__name__):
            np_box = box
        else:
            np_box = box.numpy()

        xmin = np_box[0]
        ymin = np_box[1]
        xmax = np_box[2]
        ymax = np_box[3]
        w = xmax - xmin
        h = ymax - ymin
        # print(np_box)
        np_label = label.numpy()
        key = [key for (key, value) in label_map.items() if value == np_label]
        # Create a Rectangle patch
        color = label_color_map[key[0]]
        rect = patches.Rectangle((xmin, ymin), w, h, linewidth=1, edgecolor=color, facecolor='none', label='Label')

        # Add the patch to the Axes
        ax.add_patch(rect)
        ax.text(xmin, ymin, key[0], bbox=dict(facecolor=color, alpha=0.2))
    plt.title(title)
    plt.show()


def myflip(image, boxes):
    """
    Flip image horizontally.
    :param image: image, a PIL Image
    :param boxes: bounding boxes in boundary coordinates, a tensor of dimensions (n_objects, 4)
    :return: flipped image, updated bounding box coordinates
    """
    # Flip image
    new_image = np.fliplr(image)

    # Flip boxes
    if len(boxes) == 0:
        new_boxes = boxes.clone()
    else:

        H, W, ch = image.shape
        for box in boxes:
            xmax = box[2]
            w = xmax - box[0]
            box[0] = W - (w + box[0])
            box[2] = box[0] + w

    return new_image, boxes


class HorizontalFlipTransform(object):
    """Horizontally flip the given numpy ndarray randomly with a given probability.

    Args:
        p (float): probability of the image being flipped. Default value is 0.5
    """

    def __init__(self, p=0.5):
        self.p = p

    def __call__(self, image, target):
        """
        Args:
            sample (dict):  image, mask, boxes, labels

        Returns:
            ndarray: Randomly flipped image, mask and boxes
        """
        #        mask = sample['mask']
        boxes = target['boxes']

        if random.random() < self.p:
            image, boxes = myflip(image, boxes)
            #          mask = np.fliplr(mask)
            target['boxes'] = boxes

        return image, target


class ToTensor(object):
    """Convert ndarrays in sample to Tensors."""

    def __call__(self, image, target):
        # swap color axis because
        # numpy image: H x W x C
        # torch image: C X H X W
        # 'mask': torch.from_numpy(np.flip(mask,axis=0).copy())
        image = image.transpose((2, 0, 1))
        return torch.from_numpy(np.flip(image, axis=0).copy()), target
        # return torch.as_tensor(image.transpose((2,0,1)).copy(), dtype=torch.float), target


class ResizeTransform(object):

    def __init__(self, output_size):
        assert isinstance(output_size, (int, tuple))
        self.output_size = output_size

    def __call__(self, image, target):

        boxes = target['boxes']

        h, w = image.shape[:2]
        if isinstance(self.output_size, int):
            if h > w:
                new_h, new_w = self.output_size * h / w, self.output_size
            else:
                new_h, new_w = self.output_size, self.output_size * w / h
        else:
            new_h, new_w = self.output_size

        new_h, new_w = int(new_h), int(new_w)

        new_image = transform.resize(image, (new_h, new_w))
        #        new_mask = transform.resize(mask, (new_h, new_w))

        # Resize bounding boxes
        # print('Previous',boxes)
        if len(boxes) != 0:
            x_scale = self.output_size[1] / image.shape[1]
            y_scale = self.output_size[0] / image.shape[0]
            # print(x_scale, y_scale)

            boxes[:, 0] = int(np.round(boxes[:, 0] * x_scale))
            boxes[:, 1] = int(np.round(boxes[:, 1] * y_scale))
            boxes[:, 2] = int(np.round(boxes[:, 2] * x_scale))
            boxes[:, 3] = int(np.round(boxes[:, 3] * y_scale))
            # print('new box', boxes)
            target['boxes'] = boxes

        return image, target


class Normalize(object):
    def __init__(self, mean, std):
        self.mean = mean
        self.std = std

    def __call__(self, image, target):  # realmente normalizaremos en la red

        img = image.type(torch.FloatTensor)
        dtype = img.dtype
        # #        mask = mask
        #         mean = torch.as_tensor(self.mean[:,np.newaxis], dtype=dtype, device=img.device)
        #         std = torch.as_tensor(self.std[:,np.newaxis], dtype=dtype, device=img.device)
        # img = (img - mean[:, None]) / std[:, None]
        img = img / 255
        boxes = target['boxes']
        return img, target


class Compose(object):
    def __init__(self, transforms):
        self.transforms = transforms

    def __call__(self, image, target):
        for t in self.transforms:
            image, target = t(image, target)
        return image, target

    def show_batch(batch, mean, std):
        """Mostramos las lesiones de un batch."""
        images_batch, target_batch = \
            batch[0], batch[1]
        batch_size = len(images_batch)

        # Generamos el grid
        grid = torchvision.utils.make_grid(list(images_batch))
        # Lo pasamos a numpy y lo desnormalizamos
        grid = grid.numpy().transpose((1, 2, 0))
        # esto se comenta porque realmente las imágenes no están normalizada todavía
        # mean = np.array(mean)
        # std = np.array(std)
        # grid = (std * grid + mean)
        # grid = np.clip(grid, 0, 1)
        plt.imshow(grid)
        plt.title('Batch from dataloader')


def showBB_predicted(image, target, prediction, title, only_local=True):
    boxes = target['boxes']
    labels = target['labels']
    predicted_boxes = prediction['boxes']
    predicted_labels = prediction['labels']
    scores = prediction['scores']

    label_map = {"Backgorund": 0, "Quiste": 1}
    distinct_colors = ['#FFFFFF', '#e6194b']
    label_color_map = {k: distinct_colors[i] for i, k in enumerate(label_map.keys())}

    # Display the image
    fig = plt.figure(figsize=(10, 5))
    ax = fig.add_subplot(111)
    plt.imshow(image)

    for box, label, pred_box, pred_label, score in zip(boxes, labels, predicted_boxes,
                                                       predicted_labels, scores):
        box = box.cpu()
        if (type(box).__module__ == np.__name__):
            np_box = box
        else:
            np_box = box.numpy()

        xmin = np_box[0]
        ymin = np_box[1]
        xmax = np_box[2]
        ymax = np_box[3]
        w = xmax - xmin
        h = ymax - ymin

        pred_box = pred_box.cpu()
        if (type(pred_box).__module__ == np.__name__):
            np_boxp = pred_box
        else:
            np_boxp = pred_box.numpy()

        pxmin = np_boxp[0]
        pymin = np_boxp[1]
        pxmax = np_boxp[2]
        pymax = np_boxp[3]
        pw = pxmax - pxmin
        ph = pymax - pymin
        # print(np_box)
        label = label.cpu()
        np_label = label.numpy()
        key = [key for (key, value) in label_map.items() if value == np_label]

        # Create a Rectangle patch
        color1 = label_color_map[key[0]]
        rect = patches.Rectangle((xmin, ymin), w, h, linewidth=1, edgecolor=color1, facecolor='none', label='Label')

        # Add the patch to the Axes
        ax.add_patch(rect)
        ax.text(xmin, ymin, key[0], bbox=dict(facecolor=color1, alpha=0.2))

        # Create a Rectangle patch prediction
        color2 = '#0000FF'
        rect = patches.Rectangle((pxmin, pymin), pw, ph, linewidth=1, edgecolor=color2, facecolor='none', label='Label')

        # Add the patch to the Axes prediction
        score = score.cpu()
        ax.add_patch(rect)
        ax.text(pxmin, pymin, str(score), bbox=dict(facecolor=color2, alpha=0.2))

    plt.title(title)
    plt.show()